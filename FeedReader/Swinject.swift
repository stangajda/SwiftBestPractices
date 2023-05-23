//
//  Swinject.swift
//  FeedReader
//
//  Created by Stan Gajda on 22/05/2023.
//

import Foundation
import Swinject

class Injection {
    static let shared = Injection()
    let container = Container()
    var assembler: Assembler!
    
    private init() {
        let _ = Assembler([NetworkAssembly(), ServiceAssembly(), ViewModelAssembly()], container: container)
    }
    
    func registerMockURLSession() {
        container.register(URLSessionProtocol.self) { _ in
            URLSession.mockURLSession()
        }.inObjectScope(.container)
    }
}


class NetworkAssembly: Assembly {
    func assemble(container: Container) {
        container.register(URLSessionProtocol.self) { _ in
            URLSession.configuredURLSession()
        }
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
            return AnyMovieDetailViewModelProtocol(MovieDetailViewModel(movieList: movie))
        }


//        container.register(AnyImageViewModelProtocol.self) { resolver in
//            let imagePath = resolver.resolve(String.self, name: "imagePath")!
//            let imageSizePath = resolver.resolve(ImagePathProtocol.self, name: "imageSizePath")!
//            let cache = resolver.resolve(ImageCacheProtocol.self)!
//            return AnyImageViewModelProtocol(ImageViewModel(imagePath: imagePath, imageSizePath: imageSizePath, cache: cache))
//        }
        
        container.register(AnyImageViewModelProtocol.self) { resolver , imagePath, imageSizePath, cache in
            return AnyImageViewModelProtocol(ImageViewModel(imagePath: imagePath, imageSizePath: imageSizePath, cache: cache))
        }
        
    }
}

//let container = Container()
//let assembler = Assembler([NetworkAssembly(), ViewModelAssembly()], container: container)

@propertyWrapper public struct InjectedSwinject<Service> {
    private var service: Service
    public init() {
        self.service = Injection.shared.container.resolve(Service.self)!
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
    //public var container: Resolver?
    //public var name: Resolver.Name?
    public var args: Any?
    public init() {}
//    public init(name: Resolver.Name? = nil, container: Resolver? = nil) {
//        self.name = name
//        self.container = container
//    }
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
                //self.service = container?.resolve(Service.self, name: name, args: args) ?? Resolver.resolve(Service.self, name: name, args: args)
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

extension Injection {
    fileprivate static let lock = SwinjectRecursiveLock()
}
