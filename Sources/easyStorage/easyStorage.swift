import SwiftUI
import Combine


open class StorageViewModel: ObservableObject{
    
    class Event{
        var methods: [() -> Void] = []
        
        func invoke(){
            for method in methods{
                method()
            }
        }
    }
    
    var saveEvent = Event()
    
    func save(){
        saveEvent.invoke()
    }

    func load<T, ViewModel>(file: String, data: ReferenceWritableKeyPath<ViewModel, [T]>) where T: Codable, T == Array<T>.ArrayLiteralElement, ViewModel: StorageViewModel{
        
        DocumentHelper.load(document: file, completion: { (result: (Result<[T], Error>)) in
            switch(result){
            case .success(let val):
                (self as! ViewModel)[keyPath: data] = val
            case .failure(_):
                fatalError()
            }
        })
        
        saveEvent.methods += [{
            DocumentHelper.save(document: file, data: (self as! ViewModel)[keyPath: data], completion: {result in
                switch(result){
                    case .success(_):
                        break
                    case .failure(_):
                        fatalError()
                }
            })
        }]
        
    }
}

class DocumentHelper{
    
    private static func fileURL(for document: String) throws -> URL {
            try FileManager.default.url(for: .documentDirectory,
                                           in: .userDomainMask,
                                           appropriateFor: nil,
                                           create: false)
                .appendingPathComponent(document + ".data")
        }
    
    static func load<T>(document: String, completion: @escaping (Result<[T], Error>)->Void) where T: Decodable, T == Array<T>.ArrayLiteralElement{
                do {
                    let fileURL = try fileURL(for: document)
                    guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                      
                            completion(.success([]))
                            print("file not found " + document)
                        
                        return
                    }
                    let encodedData = try JSONDecoder().decode([T].self, from: file.availableData)
                    
                        completion(.success(encodedData))
                    
                } catch {
                    
                        completion(.failure(error))
                    
                }
        }
    
    static func save<T>(document: String, data: [T], completion: @escaping (Result<Int, Error>)->Void) where T: Encodable, T == Array<T>.ArrayLiteralElement {
            DispatchQueue.global(qos: .background).async {
                do {
                    let data = try JSONEncoder().encode(data)
                    let outfile = try fileURL(for: document)
                    try data.write(to: outfile)
                    DispatchQueue.main.async {
                        completion(.success(data.count))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
}


