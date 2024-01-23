# Dependency Injection (swinject)

## Dependency injection is a design pattern that allows a program to remove hard-coded dependencies and makes it possible to change them, whether at runtime or compile time, thus making the system more modular and testable. Swinject is an open-source dependency injection framework for Swift applications, which offers a concise API to configure dependencies and inject them into classes, thus promoting loose coupling and easier unit testing.

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

### Define protocols for the services/classes you want to inject.

```protocol MovieServiceProtocol {
  func fetchMovies() -> [Movie]
}
```

### Create concrete implementation classes of these protocols.

```class MovieService: MovieServiceProtocol {
  func fetchMovies() -> [Movie] {
    // implementation
  }
}
```

### Register these implementations in the Injection class.

```Injection.main.register(MovieServiceProtocol.self) { _ in 
  MovieService()
}
```

###  Wherever you need to use these services, inject them using the @Injected property wrapper:

```@Injected var movieService: MovieServiceProtocol

func loadMovies() {
  let movies = movieService.fetchMovies() 
}
```

### The @Injected wrapper will resolve the correct implementation of MovieServiceProtocol from the Injection container.


The @Injected property wrapper allows injecting dependencies and passing arguments to them.


```let result: Result<Movies, Swift.Error> = .failure(APIError.invalidURL) 
@Injected(result) var networkResponse: NetworkResponseProtocol
```

Result<Movies, Swift.Error> is the type of the dependency we want to inject
networkResponse is the property that will hold the injected dependency
APIError.invalidURL creates a Result representing a failure with an invalid URL error
This Result is passed to the @Injected initializer as the argument
When @Injected is initialized with an argument like this, it will resolve the dependency (NetworkResponseProtocol) from the Injection container and call it with this argument.

So in this case, it will resolve an instance of NetworkResponseProtocol, and call it with the .failure(APIError.invalidURL) Result that we passed to @Injected.

This allows the mock or real NetworkResponseProtocol implementation to receive this error Result and use it in its logic.






