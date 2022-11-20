


# easyStorage

A simple, easy to use wrapper for ``ObservableObject`` to allow for persistent data storage. 


## Usage
You just use the class ``StorageViewModel`` instead of  ``ObservableObject``. In ``StorageViewModel`` there are  two notable methods:  ``load(file:, data:)`` and ``save()``.

The ``file:`` you give the ``load``-method is just an identifier for the property you want to store.

In ``load`` you load the data from the file you specify and  save it to a key path as well as register this given key path to the ``save``-method. 

I would recommend you invoke the ``load``-method in your view models initializer and the ``save``-method in an ``onDisappear``-closure in ``ContentView``.

### Example



#### ViewModel
```swift
class ViewModel: StorageViewModel{

@Published var names: [String] = []

	override init() {
	super.init()
	
	load(file: "names", data: \ViewModel.names)
	}
}
```
#### App

```swift
@main
struct MyApp: App {
    @StateObject var model: ViewModel = ViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
```


#### ContentView
```swift
struct  ContentView: View {

@EnvironmentObject  var  model: ViewModel
@State  var  nameString: String = ""

var body: some View {

	VStack {
		TextField("name", text: $nameString)
		
		Button("add Name"){
			model.names.append(nameString)
		}
		List(model.names, id: \.self){name in
			Text(name)
		}
	}
	.padding()
	.onDisappear(){	
		model.save()
		}
	}
}
```
## Credits
This package is a forked version of apples Persisting Data tutorial for SwiftUI: https://developer.apple.com/tutorials/app-dev-training/persisting-data

## Contribute
If there is any problem/feature missing please just open an issue or a pull request.

## License
easyStorage is available under the MIT License.


> Written with [StackEdit](https://stackedit.io/).

