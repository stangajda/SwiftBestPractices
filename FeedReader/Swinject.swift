//
//  Swinject.swift
//  FeedReader
//
//  Created by Stan Gajda on 22/05/2023.
//

import Foundation
import Swinject

public final class Injection {
    static let shared = Injection()
    let container = Container()
    var assembler: Assembler!
    
    private init() {
        assembler = Assembler([NetworkAssembly(), ServiceAssembly(), ViewModelAssembly()], container: container)
    }
    
    func setupTestURLSession() {
        assembler.apply(assembly: MockNetworkAssembly())
    }
    
    func setupPreviewMode() {
        assembler.apply(assembly: MockMoviesListViewModeLAssembly())
        assembler.apply(assembly: MockMovieDetailViewModelAssembly())
        assembler.apply(assembly: MockImageViewModelAssembly())
    }
    
    func setupPreviewModeDetail() {
        assembler.apply(assembly: MockMovieDetailViewModelAssembly())
        assembler.apply(assembly: MockImageViewModelItemDetailAssembly())
    }
    
}


class NetworkAssembly: Assembly {
    func assemble(container: Container) {
        container.register(URLSessionProtocol.self) { _ in
            URLSession.configuredURLSession()
        }
    }
}

class MockNetworkAssembly: Assembly {
    func assemble(container: Container) {
        container.register(URLSessionProtocol.self) { _ in
            URLSession.mockURLSession()
        }.inObjectScope(.container)
    }
}

class ServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ServiceProtocol.self) { resolver in
            Service()
        }
        
        container.register(MovieListServiceProtocol.self) { resolver in
            MovieListService()
        }
        
        container.register(MovieDetailServiceProtocol.self) { resolver in
            MovieDetailService()
        }
        
        container.register(ImageServiceProtocol.self) { resolver in
            ImageService()
        }
    }
}

class ViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AnyMoviesListViewModelProtocol.self) { _ in
            AnyMoviesListViewModelProtocol(MoviesListViewModel())
        }
        
        container.register(AnyMovieDetailViewModelProtocol.self) { resolver , movie in
            AnyMovieDetailViewModelProtocol(MovieDetailViewModel(movieList: movie))
        }
        
        container.register(AnyImageViewModelProtocol.self) { resolver , imagePath, imageSizePath, cache in
            AnyImageViewModelProtocol(ImageViewModel(imagePath: imagePath, imageSizePath: imageSizePath, cache: cache))
        }
    }
}

protocol AssemblyProtocol: Assembly {
    
}

extension AssemblyProtocol {
    func register<Service>(_ serviceType: Service.Type, container: Container, name: Injection.Name, _ factory: @escaping (Resolver) -> Service ){
        container.register(serviceType, name: name.rawValue, factory: factory)
    }
}


class MockMoviesListViewModeLAssembly: AssemblyProtocol {
    func assemble(container: Container) {
        register(AnyMoviesListViewModelProtocol.self, container: container, name: .movieListStateLoaded) { resolver in
            AnyMoviesListViewModelProtocol(MockMoviesListViewModel(.loaded))
        }

        register(AnyMoviesListViewModelProtocol.self, container: container, name: .movieListStateLoading) { resolver in
            AnyMoviesListViewModelProtocol(MockMoviesListViewModel(.loading))
        }

        register(AnyMoviesListViewModelProtocol.self, container: container, name: .movieListStateFailed) { resolver in
            AnyMoviesListViewModelProtocol(MockMoviesListViewModel(.failedLoaded))
        }
    }
}

class MockMovieDetailViewModelAssembly: AssemblyProtocol {
    func assemble(container: Container) {
        register(AnyMovieDetailViewModelProtocol.self, container: container, name: .movieDetailStateLoaded) { resolver in
            AnyMovieDetailViewModelProtocol(MockMovieDetailViewModel(.loaded, MoviesListViewModel.MovieItem.mock))
        }

        register(AnyMovieDetailViewModelProtocol.self, container: container, name: .movieDetailStateLoading) { resolver in
            AnyMovieDetailViewModelProtocol(MockMovieDetailViewModel(.loading, MoviesListViewModel.MovieItem.mock))
        }

        register(AnyMovieDetailViewModelProtocol.self, container: container, name: .movieDetailStateFailed) { resolver in
            AnyMovieDetailViewModelProtocol(MockMovieDetailViewModel(.failedLoaded, MoviesListViewModel.MovieItem.mock))
        }
    }
}

class MockImageViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AnyImageViewModelProtocol.self) { resolver , imagePath, imageSizePath, cache in
            AnyImageViewModelProtocol(MockImageViewModel(imagePath: imagePath, imageSizePath: imageSizePath, cache: cache))
        }
//        container.register(AnyImageViewModelProtocol.self) { resolver , imagePath, imageSizePath, cache in
//            return AnyImageViewModelProtocol(ImageViewModel(imagePath: imagePath, imageSizePath: imageSizePath, cache: cache))
//        }
    }
    
}

class MockImageViewModelItemDetailAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AnyImageViewModelProtocol.self) { resolver , imagePath, imageSizePath, cache in
            AnyImageViewModelProtocol(MockImageViewModelDetail(imagePath: imagePath, imageSizePath: imageSizePath, cache: cache))
        }
    }
}

//private static func registerImageViewModel() {
//    register {
//        AnyImageViewModelProtocol(MockImageViewModelLoaded()) as AnyImageViewModelProtocol
//    }
//}
//
//private static func registerImageViewModelItemDetail() {
//    register {
//        AnyImageViewModelProtocol(MockImageViewModelLoaded(.itemDetail)) as AnyImageViewModelProtocol
//    }
//}

//private static func registerMovieDetailViewModel() {
//    register(name:.movieDetailStateLoaded){
//        AnyMovieDetailViewModelProtocol(MockMovieDetailViewModel(.loaded, MoviesListViewModel.MovieItem.mock)) as AnyMovieDetailViewModelProtocol
//    }
//
//    register(name:.movieDetailStateLoading){
//        AnyMovieDetailViewModelProtocol(MockMovieDetailViewModel(.loading, MoviesListViewModel.MovieItem.mock)) as AnyMovieDetailViewModelProtocol
//    }
//
//    register(name:.movieDetailStateFailed){
//        AnyMovieDetailViewModelProtocol(MockMovieDetailViewModel(.failedLoaded, MoviesListViewModel.MovieItem.mock)) as AnyMovieDetailViewModelProtocol
//    }
//}

//let container = Container()
//let assembler = Assembler([NetworkAssembly(), ViewModelAssembly()], container: container)

//@propertyWrapper public struct Injected<Service> {
//    private var service: Service
//    public init() {
//        self.service = Resolver.resolve(Service.self)
//    }
//    public init(name: Resolver.Name? = nil, container: Resolver? = nil) {
//        self.service = container?.resolve(Service.self, name: name) ?? Resolver.resolve(Service.self, name: name)
//    }
//    public var wrappedValue: Service {
//        get { return service }
//        mutating set { service = newValue }
//    }
//    public var projectedValue: Injected<Service> {
//        get { return self }
//        mutating set { self = newValue }
//    }
//}

@propertyWrapper public struct InjectedSwinject<Service> {
    private var service: Service
    
    public init() {
        self.service = Injection.shared.container.resolve(Service.self)!
    }
    public init(name: Injection.Name? = nil) {
        self.service = Injection.shared.container.resolve(Service.self, name: name?.rawValue) ?? Injection.shared.container.resolve(Service.self, name: name?.rawValue)!
    }
    public var wrappedValue: Service {
        get { return service }
        mutating set { service = newValue }
    }
    public var projectedValue: InjectedSwinject<Service> {
        get { return self }
        mutating set { self = newValue }
    }
}

@propertyWrapper struct InjectedSwinject2<Dependency> {
  let wrappedValue: Dependency
 
  init() {
    self.wrappedValue =
            Injection.shared.container.resolve(Dependency.self)!
  }
}

@propertyWrapper struct LazyInjectedSwinject2<Dependency> {
  lazy var wrappedValue: Dependency = {
    Injection.shared.container.resolve(Dependency.self)!
  }()
 
  init() {
    
    self.wrappedValue =
            Injection.shared.container.resolve(Dependency.self)!
  }
}

@propertyWrapper public struct LazyInjectedSwinject<Service> {
    private var lock = Injection.lock
    private var initialize: Bool = true
    private var service: Service!
    public init() {}
    public var isEmpty: Bool {
        lock.lock()
        defer { lock.unlock() }
        return service == nil
    }
    public var wrappedValue: Service {
        mutating get {
            lock.lock()
            defer { lock.unlock() }
            if initialize {
                self.initialize = false
                self.service = Injection.shared.container.resolve(Service.self)
            }
            return service
        }
        mutating set {
            lock.lock()
            defer { lock.unlock() }
            initialize = false
            service = newValue
        }
    }
    public var projectedValue: LazyInjectedSwinject<Service> {
        get { return self }
        mutating set { self = newValue }
    }
    public mutating func release() {
        lock.lock()
        defer { lock.unlock() }
        self.service = nil
    }
}


private final class SwinjectRecursiveLock {
    init() {
        pthread_mutexattr_init(&recursiveMutexAttr)
        pthread_mutexattr_settype(&recursiveMutexAttr, PTHREAD_MUTEX_RECURSIVE)
        pthread_mutex_init(&recursiveMutex, &recursiveMutexAttr)
    }
    @inline(__always)
    final func lock() {
        pthread_mutex_lock(&recursiveMutex)
    }
    @inline(__always)
    final func unlock() {
        pthread_mutex_unlock(&recursiveMutex)
    }
    private var recursiveMutex = pthread_mutex_t()
    private var recursiveMutexAttr = pthread_mutexattr_t()
}

extension Injection.Name {
    
    static let movieListStateLoaded = Self("MovieListStateLoaded")
    static let movieListStateLoading = Self("MovieListStateLoading")
    static let movieListStateFailed = Self("MovieListStateFailed")
    
    static let movieDetailStateLoaded = Self("MovieDetailStateLoaded")
    static let movieDetailStateLoading = Self("MovieDetailStateLoading")
    static let movieDetailStateFailed = Self("MovieDetailStateFailed")
    
    static let imageStateLoaded = Self("ImageStateLoaded")

    static let itemList = Self("ItemList")
    static let itemDetail = Self("ItemDetail")
}

extension Injection {
    fileprivate static let lock = SwinjectRecursiveLock()
}

extension Injection {

    public struct Name: ExpressibleByStringLiteral, Hashable, Equatable {
        public let rawValue: String
        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }
        public init(stringLiteral: String) {
            self.rawValue = stringLiteral
        }
        public static func name(fromString string: String?) -> Name? {
            if let string = string { return Name(string) }
            return nil
        }
        static public func == (lhs: Name, rhs: Name) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }
        public func hash(into hasher: inout Hasher) {
            hasher.combine(rawValue)
        }
    }

}
