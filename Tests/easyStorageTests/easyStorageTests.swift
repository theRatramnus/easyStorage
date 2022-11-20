import XCTest
@testable import easyStorage

final class easyStorageTests: XCTestCase {
    func testExample() throws {
        class Store: StorageViewModel{
            @Published var names: [String] = []
            override init() {
                super.init()
                load(file: "names", data: \Store.names)
                names = ["me", "you", "him"]
                save()
                load(file: "names", data: \Store.names)
                print(names)
            }
        }
        XCTAssertEqual(Store().names, ["me", "you", "him"])
    }
}
