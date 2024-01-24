# MVVM Architecture with States

## The Model-View-ViewModel (MVVM) architecture with states facilitates a clear separation of concerns by binding the UI components to observable variables and states, which allows the UI to update reactively as the data changes. This pattern helps in managing UI states more efficiently, making the codebase easier to maintain and test, especially in complex applications with dynamic and interactive user interfaces.

## Good uses:

- **Complex User Interfaces:** MVVM is excellent for applications with complex UIs where you need to manage multiple UI states based on the data model.
- **Data Binding:** It works well in scenarios where data binding is used extensively since the ViewModel can expose data and command objects that the View can bind to.
- **Testability:** If you want to write unit tests for presentation logic without requiring the View, MVVM is a good choice because the ViewModel does not have a reference to the View.
- **Decoupled Code:** When you want a clear separation of concerns, making it easier to maintain and extend the codebase.
- **Reactive Programming:** MVVM with states fits well with reactive programming patterns and frameworks, which can help manage state changes and UI updates more smoothly.

## Less ideal uses:

- **Simple UIs:** For simple applications with a straightforward UI and minimal interaction, MVVM can be overkill and add unnecessary complexity.
- **Learning Curve:** If the development team is not familiar with MVVM or state management, the learning curve might slow down the development process.
- **Performance Considerations:** In scenarios where performance is critical, and the overhead of data binding and observing state changes can be a bottleneck, MVVM might not be the best option.
- **Boilerplate Code:** MVVM can lead to an increase in the amount of boilerplate code, which can make the codebase more verbose and harder to understand for new developers.

## Implementing MWWM State Management

### Overview
The MWWM (Model-View-ViewModel) architecture separates an app into three components:
- Model - Manages the data and business logic of the app
- View - Displays the UI and handles user interactions
- ViewModel - Mediates between the Model and View, preparing data for display and handling view logic

A key part of MWWM is managing state - the data and status of the view at any given point. This is handled in the ViewModel using a state machine.

### Implementing State
The ViewModel manages state using the LoadableProtocol. This defines the state machine and handles transitions between states.

The states are defined in an enum:
```swift
enum State {
  case start
  case loading
  case loaded(Result) 
  case failedLoaded(Error)
}
```

## ViewModel and View Implementation

### ViewModel

### Understanding the Protocol

First, let's understand the MoviesListViewModelProtocol:

```swift
protocol MoviesListViewModelProtocol: LifecycleProtocol, ObservableLoadableProtocol
  where TP1 == [MoviesListViewModel.MovieItem], TP2 == Int {
  func onActive()
  func onBackground()
}
```

This protocol inherits from two other protocols: LifecycleProtocol and ObservableLoadableProtocol. Additionally, it specifies two associated types (TP1 and TP2) with specific types: TP1 is an array of MovieItem, and TP2 is an Int. The protocol also requires conforming types to implement two functions: onActive() and onBackground().

Implementing the ViewModel Class
To implement a class that conforms to MoviesListViewModelProtocol, you need to follow these steps:

### Define State and Service

The MoviesListViewModel holds a state property which is marked with @Published to enable SwiftUI's data flow mechanism. It also has a service property to handle data fetching, which is injected into the view model.

```swift
final class MoviesListViewModel: MoviesListViewModelProtocol {
  @Published fileprivate(set) var state = State.start()
  @Injected fileprivate var service: MovieListServiceProtocol
  // ...
}
```

### Define Typealiases

Define the typealiases TP1 and TP2 as specified in the protocol to be used within the class:

```swift
typealias TP1 = [MovieItem]
typealias TP2 = Int
```

### Handle Actions with a Subject

The input property is a PassthroughSubject that can be used to send actions to the view model.

```swift
var input = PassthroughSubject<Action, Never>()
```

### Manage Subscriptions

The cancellable property is used to hold a reference to the subscription so it can be canceled later.

```swift
fileprivate var cancellable: AnyCancellable?
```

### Initialize State Publisher

The init() function initializes the statePublisher and triggers the onAppear() function.

```swift
init() {
  statePublisher = _state.projectedValue
  onAppear()
}
```

### Implement Lifecycle Functions

Implement the onAppear, onDisappear, onActive, and onBackground functions to handle view lifecycle events. These methods are used to start and stop any processes or subscriptions when the view appears or disappears.

```swift
func onAppear() {
  cancellable = self.assignNoRetain(self, to: \.state)
  send(action: .onAppear)
}

func onDisappear() {
  send(action: .onReset)
  cancellable?.cancel()
}

func onActive() {
  onAppear()
}

func onBackground() {
  onDisappear()
}
```

Additional Details
statePublisher is used to publish changes to state so that the UI can be updated reactively.
assignNoRetain is a custom function (not shown in the snippet) that presumably assigns the output of a publisher to a property without retaining the self.
send(action:) is another custom function (also not shown) that is used to handle actions sent to the view model.

### Implement fetch Data

In View Model you implement `fetchData` in extension ViewModel


```swift
extension ViewModel {

  // Fetch data from API
  func fetchData() -> AnyPublisher<[ViewModelItem], Error> {
    
    // Call service to get data
    return self.service.fetch(urlRequest)
  
      // Map API models to view model items
      .map { apiModels in
        apiModels.map { ViewModelItem.init }  
      }
      
      // Erase publisher type to AnyPublisher
      .eraseToAnyPublisher()
  }
}
```


### View

The `MoviesListView` is a SwiftUI view that renders UI elements based on the state of the movies data, which is managed by `MoviesListViewModel`.

The `MoviesListView` is structured as follows:

```swift
struct MoviesListView: View {

  @ObservedObject var viewModel: MoviesListViewModel

  var body: some View {
    switch viewModel.state {
      case .loaded(let movies):
        // Code to show movies goes here
      
      case .loading:
        // Code to show a loading indicator goes here
    }
  }
}
```


