# Factory Instance

## The factory singleton pattern can be useful for caching expensive instances globally, but should be avoided if loose coupling and testability are higher priorities.

## Good uses:

- **Singleton Pattern**: This is beneficial when you want to ensure that only one instance of a class exists for a given input parameter, preventing the creation of multiple instances unnecessarily.
- **Global Access Point**: The factory provides a single method to access the instance, which is useful when you need a global access point to get the same instance in different parts of the code.
- **Instance Reusability**: If you want to cache and reuse instances instead of recreating them, the factory can return an existing instance if it already exists.
- **Efficient API Calls**: The singleton pattern can help reduce unnecessary API calls by reusing existing instances. This can lead to performance improvements and more efficient use of resources.


## Less ideal uses:

- **Lightweight Instances**: The singleton pattern is less ideal when instances are lightweight and don't require caching.
- **Modularity and Coupling**: If you prefer a more modular, loosely coupled design, the singleton pattern may not be suitable as it introduces tight coupling between the factory and the class instances.
- **Testability**: If easy testability is a priority, dependency injection may be a better choice.
- **Global State**: Sharing state globally can lead to problems and may not be necessary.
- **Code Understandability**: The singleton pattern hides the instantiation logic, which can make the code harder to understand.
- **Overuse of Singletons**: Overusing singletons can make code more rigid and less modular.

## Implementing Factory Instances

- **Static Dictionary Property**: Declare a static dictionary property to store instances. The key should be some unique identifier like an ID.
- **Static Factory Method**: Create a static factory method that takes in the required parameters.
- **Instance Checking**: In the factory method, check if an instance already exists for the given key. If it exists, return the existing instance. If not, create a new instance, store it in the dictionary, and return it.
- **Instance Removal**: Provide a way to remove instances, like a `static instances.removeValue(forKey: movieListId)` method.
- **Usage**: When using it, call the factory method to get an instance. Pass the same parameters to always get the same instance back. Call removeInstance() when needed to delete the instance.
- **Instance Creation and Caching**: The factory method handles instance creation and caching. Code using the factory doesn't need to know about the instance cache.
- **Privacy and Control**: Keeps instances private and controlled through the factory.
- **Avoid Global State**: Avoid making properties/state shared globally this way. Use dependency injection.

```swift
// Declare a static dictionary to store instances 
static var instances: [Int: MovieDetailViewModel] = [:] 

// Factory method to return instance
static func instance(_ movieList: MoviesListViewModel.MovieItem) -> MovieDetailViewModel {

  // Set ID to use as dictionary key
  movieListId = movieList.id

  // Check if instance for key already exists
  if let instance = instances[movieListId] {
    
    // Return existing instance if found
    return instance 

  } else {

    // Create new instance if not found
    let instance = MovieDetailViewModel(movieList)
    
    // Store new instance in dictionary
    instances[movieList.id] = instance
    
    // Return new instance
    return instance
  }
}

// Method to remove instance from dictionary
static func deallocateCurrentInstances() {
  instances.removeValue(forKey: movieListId) 
}
```
