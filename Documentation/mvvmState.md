# MVVM Architecture with States

## When to Use MVVM with States

### Good Use Cases for MVVM with States:

1. **Complex User Interfaces:** MVVM is excellent for applications with complex UIs where you need to manage multiple UI states based on the data model.
2. **Data Binding:** It works well in scenarios where data binding is used extensively since the ViewModel can expose data and command objects that the View can bind to.
3. **Testability:** If you want to write unit tests for presentation logic without requiring the View, MVVM is a good choice because the ViewModel does not have a reference to the View.
4. **Decoupled Code:** When you want a clear separation of concerns, making it easier to maintain and extend the codebase.
5. **Reactive Programming:** MVVM with states fits well with reactive programming patterns and frameworks, which can help manage state changes and UI updates more smoothly.

## When Not to Use MVVM with States

### Not Good Use Cases for MVVM with States:

1. **Simple UIs:** For simple applications with a straightforward UI and minimal interaction, MVVM can be overkill and add unnecessary complexity.
2. **Learning Curve:** If the development team is not familiar with MVVM or state management, the learning curve might slow down the development process.
3. **Performance Considerations:** In scenarios where performance is critical, and the overhead of data binding and observing state changes can be a bottleneck, MVVM might not be the best option.
4. **Boilerplate Code:** MVVM can lead to an increase in the amount of boilerplate code, which can make the codebase more verbose and harder to understand for new developers.

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
### LoadableProtocol

The `LoadableProtocol` has a `reduce` function that handles transitioning between states based on actions:

```swift
func reduce(_ state: State, _ action: Action) -> State {
  // Transition logic
}
```

## ViewModel and View Implementation

### ViewModel

The ViewModel should conform to protocols that enable:

- **Observable state** - `ObservableObject` allows SwiftUI to observe and update when state changes
- **Lifecycle handling** - `onAppear`, `onDisappear` etc to react to View lifecycles
- **Input actions** - `PassthroughSubject` allows the View to send actions to the ViewModel

For example:

```swift
class ViewModel: ObservableObject, LifecycleProtocol {

  // @Published state
  @Published var movies = [Movie]()

  // Input from View
  var input = PassthroughSubject<Action, Never>()

  // Lifecycle methods
  func onAppear() {
    // Load data
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


