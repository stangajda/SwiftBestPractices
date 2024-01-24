# Any Protocol

## AnyProtocol wrapper pattern shines when you need abstraction and polymorphism over protocols, but adds some overhead. It may not be suitable if you need concrete type information. 

## Good uses:

- When you use a type alias in a protocol like 'typealias ViewModel = MovieDetailViewModel', and the Swift compiler forces you to use 'any MovieDetailViewModelProtocol', there can be issues using dependency injection through the protocols.
- When you want to abstract away concrete types and only deal with protocols. This decouples code from specific implementations.
- When you need to pass around instances conforming to a protocol without exposing their concrete types. The wrapper hides the implementation details.
- When you want to write generic code that can handle any type conforming to a protocol. The wrapper provides a consistent interface.
- When you need to mock or stub protocols for testing. The wrapper allows injecting mock implementations.
- When you want to conditionally switch implementations at runtime. The wrapper provides a common interface to swap them.

## Less ideal uses:

- When you don't use type alias in protocols and swift compiler don't force you to use 'any MovieDetailViewModelProtocol'
- When the concrete types do not actually differ in any significant way. The wrapper just adds unnecessary abstraction.
- When you need access to properties or methods not defined in the protocol. The wrapper limits you to just the protocol.
- When the performance overhead of delegation and indirection causes issues. The wrapper adds some small overhead.
- When you need to downcast to concrete types anyway. The wrapper prevents useful type information.

## Implementing Any Protocol

- It inherits from BaseViewModelWrapper which contains common logic for wrapping view model state, input and publishers.
- It declares the associated type requirements from MoviesListViewModelProtocol like TP1.
- It has a fileprivate property to store the concrete view model being wrapped.
- The init takes a concrete view model and passes it to the parent BaseViewModelWrapper init.
- It implements all the required functions from MoviesListViewModelProtocol by simply calling through to the wrapped view model.
- The eraseToAnyViewModelProtocol extension function allows easy conversion from a concrete view model to AnyMoviesListViewModelProtocol.

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



