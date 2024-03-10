# Optimisation

## Image Caching 

An image cache is used to store downloaded images in memory, avoiding duplicate network requests and providing a smoother user experience. The most recently used images are kept in the cache while older images are evicted as needed.

```swift  
struct ImageCache {
    static let totalCostLimit = 50_000_000
}

struct TemporaryImageCache: ImageCacheProtocol {
fileprivate let cache = NSCache<NSURL, UIImage>()

init() {
    cache.totalCostLimit = Config.ImageCache.totalCostLimit
}

subscript(_ key: URL) -> UIImage? {
    get {
        cache.object(forKey: key as NSURL)
    }
    set {
        guard let newValue = newValue else {
            cache.removeObject(forKey: key as NSURL)
            return
        }
        cache.setObject(newValue, forKey: key as NSURL)
    }
}

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCacheProtocol = TemporaryImageCache()
}

extension EnvironmentValues {
   var imageCache: ImageCacheProtocol {
        get {
            self[ImageCacheKey.self]
        }
        set {
            self[ImageCacheKey.self] = newValue
        }
    }
}
```

## Request caching 

API requests are cached to avoid duplicate requests. The cache policy can be configured based on requirements. This improves performance and reduces network usage.

```swift
extension URLSession {
    static var `default`: URLSession {
        let configuration = URLSessionConfiguration.default
        let urlCache = URLCache(memoryCapacity: 20_000_000, diskCapacity: 50_000_000)
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 180
        configuration.httpMaximumConnectionsPerHost = 7
        configuration.urlCache = urlCache
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return URLSession(configuration: configuration)
    }
}
```

## Back button pressed cancelation

When the user presses the back button, the download feed and image are cancelled.
```swift
var body: some View {
        ...
        .onDisappear {
            viewModel.onDisappear()
        }
}

func onDisappear() {
    send(action: .onReset)
    cancellable?.cancel()
}
```

## One instance view model

Views are singletons to avoid creating multiple instances of the same view and call unnecessary requests.

```swift
static func instance(_ movieList: MoviesListViewModel.MovieItem) -> MovieDetailViewModel {
    movieListId = movieList.id
    if let instance = instances[movieListId] {
        return instance
    } else {
        let instance = MovieDetailViewModel(movieList)
        instances[movieList.id] = instance
        return instance
    }
}
```

## Reactive Programming 

The reactive programming with Combine framework is tightly integrated to update the UI in response to data changes, further simplifying the codebase and performance.

```swift
struct MovieDetailService: MovieDetailServiceProtocol {
    @Injected var service: ServiceProtocol
    fileprivate let queue = DispatchQueue(label: Config.QueueMovieDetail.label, qos: Config.QueueMovieDetail.qos)
    func fetchMovieDetail(_ request: URLRequest) -> AnyPublisher<MovieDetail, Error> {
        return self.service.fetchData(request)
            .subscribe(on: queue)
            .eraseToAnyPublisher()
    }
}
```
