# Feedback and System Patterns in Combine

## In the context of Apple's Combine framework, feedback and system patterns are used to model and manage state and side effects in a reactive programming style. The feedback loop pattern allows the system to react to state changes and user actions by emitting events that are then handled in a way that may affect the state again, creating a controlled loop of interactions.

## Good uses:


- **Managing Stateful Logic:** These patterns excel in scenarios where the system's state changes in response to various events. They simplify state management by decomposing it into a series of state transformations in response to actions.
- **Complex User Interactions:** Applications with complex user interfaces and interactions can benefit from these patterns, as they can manage the state transitions in a predictable and organized manner.
- **Reactive Systems:** For systems that need to react to various events and maintain state consistency across different parts of the application, the Feedback and System patterns provide a structured approach to propagate changes through the system.
- **Decoupling Components:** They help in achieving a decoupled architecture by isolating side effects from the state and action handling logic, which leads to a more maintainable and testable codebase.

## Less ideal uses:

- **Simple State Management:** In cases where state management is straightforward and does not involve complex state transitions or side effects, using these patterns could be over-engineering.
- **One-off Events:** For handling events that occur once or follow a simple flow, traditional completion blocks or delegation may be more appropriate and less complex.
- **Learning Curve:** If the development team is not well-versed in reactive programming concepts, these patterns might introduce unnecessary complexity and can have a steep learning curve.
- **Performance Considerations:** In performance-sensitive parts of the code, the overhead introduced by reactive programming and the use of these patterns might not be justified.


## Implementing System and Feedback

### System

Overall, this system architecture manages complexity through separation of concerns, immutability, and declarative reactive flows. It balances power and simplicity for maintainable and extensible code.

- **Centralizes and makes the state immutable** using the state pattern.
- **Triggers state changes with actions** that return new states.
- **Employs reducers** as pure functions that take the current state and action to produce a new state.
- **Utilizes feedback loops** that listen for state changes and perform effects like API calls.
- **Encapsulates asynchronous loading state** with a Loadable protocol.
- **Uses generics** for reusability across different state types.
- **Controls the timing of state changes** with a scheduler.
- **Is composable** - multiple feedback loops can be combined.
- **Is testable** - state changes can be asserted without UI.
- **Adopts a declarative style** that makes flows readable.
- **Handles lifecycle** with declarative subscriptions.

```swift
extension Publishers {
    static func system<State, Action, Scheduler: Combine.Scheduler>( // A publisher that emits the current state of the state machine.
        initial: State,
        // The initial state of the state machine.
        reduce: @escaping (State, Action) -> State,
        // A closure that takes the current state and an action, and returns the new state.
        scheduler: Scheduler,
        // The scheduler on which to run the state machine.
        feedbacks: [Feedback<State, Action>]
        // An array of Feedback loops that produce actions based on the current state.
    ) -> AnyPublisher<State, Never> {
        // Create a subject that holds the current state and emits it to its subscribers.
        let state = CurrentValueSubject<State, Never>(initial)
        // Map each feedback loop to a publisher that runs the loop with the current state.
        let events = feedbacks.map { feedback in
            feedback.run(state.eraseToAnyPublisher())
        }
        return Deferred {
            // Merge the events from all feedback loops into a single stream of actions.
            Publishers.MergeMany(events)
                .receive(on: scheduler) // Ensure the merged events are received on the specified scheduler.
                // Use the `scan` operator to reduce the state based on the incoming actions.
                .scan(initial, reduce)
                // Use `handleEvents` to update the `state` subject every time a new state is produced.
                .handleEvents(receiveOutput: state.send)
                .receive(on: scheduler) // Again ensure events are received on the scheduler.
                // Prepend the initial state so that it is emitted first.
                .prepend(initial)
                .eraseToAnyPublisher() // Return type as `AnyPublisher` to hide implementation details.
        }
        .eraseToAnyPublisher() // Return type as `AnyPublisher` for the deferred publisher.
    }

}
```

### Feedback

- **Feedback loop listens for state changes** and maps them to effects that return actions.
- **Implements the feedback pattern** to manage side effects and decouple view models from making network calls directly.
- **Feedback struct encapsulates a closure** that takes a stream of state and returns a stream of actions. This allows side effects to be defined separately from the view models.
- **Effects are defined as functions** that take the state and return a publisher of actions. This keeps side effects reusable and testable.
- **Feedback loop is created** by piping state into the run closure, which switches over the different effects publishers and maps them to actions.
- **Using feedback with reactive streams** creates a unidirectional data flow architecture. State flows downstream through pure functions into effects and back upstream as actions.

```swift

// Extend the Feedback struct to add an initializer.
extension Feedback {
    
    /// Initializes a Feedback with an effects closure.
    /// - Parameter effects: A closure that takes the current state and returns an effect as a publisher,
    ///                      which outputs actions and never fails.
    init<Effect: Publisher>(effects: @escaping (State) -> Effect)
    where Effect.Output == Action, Effect.Failure == Never {
        // Define the `run` closure.
        self.run = { state -> AnyPublisher<Action, Never> in
            // Take the incoming state publisher and transform it into a new publisher of actions.
            state
                // Use the `map` operator to apply the `effects` closure to each emitted state,
                // which returns a publisher of actions.
                .map { item in
                    effects(item) }
                // The `switchToLatest` operator takes a publisher that emits publishers (like the one we get from `map`)
                // and switches to the latest emitted publisher, cancelling the subscription to the previous one.
                // This is useful for cases where the state changes rapidly and you only care about the latest state.
                .switchToLatest()
                // Erase the type of publisher to `AnyPublisher` to hide implementation details.
                .eraseToAnyPublisher()
        }
    }
}
```

### Loadable protocol

- **It is a protocol** that view models can conform to in order to implement loading state functionality

- **It has associated types GENERIC_REQ_TYPE and GENERIC_RES_TYPE** which are the loaded data result type and loading identifier type

- **It defines a State enum using LoadableEnums** to represent loading states like start, loading, loaded, failed

- **It defines an Action enum** for actions like onAppear, onLoaded, onFailed, onReset

- **It has an input PassthroughSubject** to send actions to

- **It has a fetch() function** to actually load data and return a publisher

- **It implements a reduce()** function to handle state transitions based on actions

- **It uses a publishersSystem() publisher** to combine state, reduce, and feedbacks

- **Feedback is used to transition** from loading to loaded/failed when fetch completes

- **onStateChanged feedback** maps fetch result to onLoaded/onFailed actions

- **userInput feedback** sends user input actions from input subject

- **send(action:) utility function** to send actions to input subject


```swift

import Combine

protocol LoadableProtocol {

  func fetch() -> AnyPublisher<Data, Error>

  // Feedback

  // Create feedback to start fetch on loading state
  private func onStateChanged() -> Feedback<State, Action> {
    
    Feedback { state -> AnyPublisher<Action, Never> in

      // Only trigger on loading state
      guard case .loading = state else { 
        return Empty().eraseToAnyPublisher() 
      }

      // Start fetch
      return self.fetch()

        // Map fetch result to action
        .map { data in
          Action.onLoaded(data) 
        }
        
        // Map error to action
        .catch { error in
          Just(Action.onError(error))
        }
        
        // Publisher with no failure
        .eraseToAnyPublisher()
    }
  }

  // Create feedback for user input
  private func userInput(input: AnyPublisher<Action, Never>) -> Feedback<State, Action> {

    Feedback { _ in
      input 
    }
  }
  
}
```






