//
//  DIWrapper.swift
//  FeedReader
//
//  Created by Stan Gajda on 24/05/2023.
//

import Foundation

// MARK:- Injected
@propertyWrapper public struct Injected<Service> {
    private var service: Service
    
    public init() {
        self.service = Injection.resolver.resolve(Service.self)
    }
    
    public init(name: Injection.Name? = nil) {
        self.service = Injection.resolver.resolve(Service.self, name: name?.rawValue) ?? Injection.resolver.resolve(Service.self)
    }
    
    public init<ARG1>(_ argument1: ARG1) {
        self.service = Injection.resolver.resolve(Service.self, argument: argument1) ?? Injection.resolver.resolve(Service.self)
    }
    
    public init<ARG1, ARG2>(_ argument1: ARG1, _ argument2: ARG2) {
        self.service = Injection.resolver.resolve(Service.self, arguments: argument1, argument2) ?? Injection.resolver.resolve(Service.self)
    }
    
    public init<ARG1, ARG2, ARG3>(_ argument1: ARG1, _ argument2: ARG2, _ argument3: ARG3) {
        self.service = Injection.resolver.resolve(Service.self, arguments: argument1, argument2, argument3) ?? Injection.resolver.resolve(Service.self)
    }
    
    public var wrappedValue: Service {
        get { return service }
        mutating set { service = newValue }
    }
    
    public var projectedValue: Injected<Service> {
        get { return self }
        mutating set { self = newValue }
    }
}

// MARK:- LazyInjected
@propertyWrapper public struct LazyInjected<Service> {
    private var lock = Injection.lock
    private var initialize: Bool = true
    private var service: Service?
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
                self.service = Injection.resolver.resolve(Service.self)
            }
            guard let service = service else {
                fatalError("Can not find Service")
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
    public var projectedValue: LazyInjected<Service> {
        get { return self }
        mutating set { self = newValue }
    }
    public mutating func release() {
        lock.lock()
        defer { lock.unlock() }
        self.service = nil
    }
}

// MARK:- Lock
extension Injection {
    fileprivate static let lock = SwinjectRecursiveLock()
}

// MARK:- SwinjectRecursiveLock
fileprivate final class SwinjectRecursiveLock {
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
