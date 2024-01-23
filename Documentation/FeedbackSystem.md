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

- **Define the State and Action types**
- **Provide the initial state**
- **Implement the reduce function** that handles state transitions
- **Specify the scheduler**
- **Create Feedback loops**

### System

```swift
extension Publishers {
  static func system<State, Action, Scheduler: Combine.Scheduler>(
      initial: State,
      reduce: @escaping (State, Action) -> State,
      scheduler: Scheduler,
      feedbacks: [Feedback<State, Action>]
  ) -> AnyPublisher<State, Never> {
    // Implementation
  }
}
```

### Feedback

The Feedback loop listens for state changes and maps them to effects that return actions.

1. **Define a Feedback struct** with a run function
2. **Implement run** to map state to effects, flatten, and return actions
3. **Add Feedback loops to System**

### Example

```swift
struct Feedback<State, Action> {
  let run: (AnyPublisher<State, Never>) -> AnyPublisher<Action, Never>
}
```



