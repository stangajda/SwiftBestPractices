# Any Protocol

## AnyProtocol wrapper pattern shines when you need abstraction and polymorphism over protocols, but adds some overhead. It may not be suitable if you need concrete type information. 

## Good uses:

- **Type Alias in Protocols**: When you use a type alias in a protocol like 'typealias ViewModel = MovieDetailViewModel', and the Swift compiler forces you to use 'any MovieDetailViewModelProtocol', there can be issues using dependency injection through the protocols.
- **Abstraction Over Concrete Types**: This pattern is useful when you want to abstract away concrete types and only deal with protocols. This decouples code from specific implementations.
- **Hiding Implementation Details**: The wrapper is beneficial when you need to pass around instances conforming to a protocol without exposing their concrete types.
- **Generic Code**: The wrapper provides a consistent interface, which is advantageous when you want to write generic code that can handle any type conforming to a protocol.
- **Mocking for Testing**: The wrapper allows injecting mock implementations, which is useful when you need to mock or stub protocols for testing.
- **Switching Implementations at Runtime**: The wrapper provides a common interface to swap implementations, which is beneficial when you want to conditionally switch implementations at runtime.

## Less ideal uses:

- **No Type Alias in Protocols**: The pattern is less ideal when you don't use type alias in protocols and the Swift compiler doesn't force you to use 'any MovieDetailViewModelProtocol'.
- **Unnecessary Abstraction**: The wrapper just adds unnecessary abstraction when the concrete types do not actually differ in any significant way.
- **Limited Access to Properties/Methods**: The wrapper limits you to just the protocol, which is a disadvantage when you need access to properties or methods not defined in the protocol.
- **Performance Overhead**: The wrapper adds some small overhead, which can cause issues when the performance overhead of delegation and indirection is a concern.
- **Loss of Useful Type Information**: The wrapper prevents useful type information, which is a disadvantage when you need to downcast to concrete types.

## Implementing Any Protocol

- **Inheritance**: It inherits from BaseViewModelWrapper which contains common logic for wrapping view model state, input, and publishers.
- **Associated Type Requirements**: It declares the associated type requirements from MoviesListViewModelProtocol like TP1.
- **Fileprivate Property**: It has a fileprivate property to store the concrete view model being wrapped.
- **Initialization**: The init takes a concrete view model and passes it to the parent BaseViewModelWrapper init.
- **Function Implementation**: It implements all the required functions from MoviesListViewModelProtocol by simply calling through to the wrapped view model.
- **Extension Function**: The eraseToAnyViewModelProtocol extension function allows easy conversion from a concrete view model to AnyMoviesListViewModelProtocol.

```swift
// Inherit from BaseViewModelWrapper to get common wrapper logic
class AnyMoviesListViewModelProtocol: BaseViewModelWrapper<MoviesListViewModel.State, MoviesListViewModel.Action>,  
    MoviesListViewModelProtocol {

  // Declare associated types required by protocol
  typealias ViewModel = MoviesListViewModel
  typealias TP1 = [ViewModel.MovieItem]

  // Property to store actual view model being wrapped
  fileprivate var viewModel: any MoviesListViewModelProtocol

  // Initializer accepts a concrete view model and passes to parent init
  init<ViewModel: MoviesListViewModelProtocol>(_ viewModel: ViewModel) {
    self.viewModel = viewModel
    super.init(state: viewModel.state,
               input: viewModel.input,
               statePublisher: viewModel.statePublisher)
  }

  // Implement protocol functions by calling through to wrapped view model
  func onAppear() {
    viewModel.onAppear() 
  }

  func onDisappear() {
    viewModel.onDisappear()
  }

  // ...other protocol functions  

  // Function to easily wrap a view model in the wrapper 
  func eraseToAnyViewModelProtocol() -> AnyMoviesListViewModelProtocol {
    return AnyMoviesListViewModelProtocol(self)
  }
}
```



