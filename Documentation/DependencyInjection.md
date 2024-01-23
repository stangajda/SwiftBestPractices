# Dependency Injection

## Good Uses

- **Injecting network services** - Allows swapping real and mock implementations for testing
- **Injecting data repositories** - Decouples view models from concrete data sources
- **Injecting view models** - Allows providing mocked view models during testing
- **Configuring image caching** - Can inject different cache settings based on environment

## Less Ideal Uses

- **Injecting small utility classes** - Adds unnecessary complexity for simple dependencies
- **Injecting view components** - Views don't often have dependencies, so DI provides less benefit
- **Singletons or app-wide instances** - DI works best for scoped dependencies vs singletons
- **Tightly coupled classes** - If classes are tightly coupled, DI won't help decouple them

## Implementing Dependency Injection

This project uses the **Swinject** library for dependency injection.

### Registering Dependencies

Dependencies are registered in the Assembler files (e.g. `NetworkAssembly.swift`). Each Assembler registers a specific type of dependencies.

### Initializing Dependency Injection

The `AppDelegate` calls the `injectDependency()` method during app launch, which initializes the dependency injection container and calls the assemblers to register all dependencies.

### Accessing the Dependency Injection Container

The `Injection` class provides access to the dependency injection container via its static `resolver` property.

### Injecting Dependencies

Dependencies are injected into classes using the `@Injected` property wrapper. For example:

```swift
@Injected var networkService: NetworkService
```

### Resolving Dependencies

This will resolve the `NetworkService` from the container and inject it.

### Overriding Dependencies for Testing

Dependencies can be overridden for testing using the mock assemblers (e.g. `MockNetworkAssembly`).

### Passing Arguments During Resolution

Additional arguments can be passed during resolution using the `Injected` initializer.

### Summary

- Register dependencies in Assembler files
- Initialize dependency injection in `AppDelegate`
- Use `@Injected` property wrapper to inject dependencies
- Override with mock dependencies for testing
- Pass arguments to customize resolution

This provides a clean way to manage dependencies and makes testing easier by allowing overrides.






