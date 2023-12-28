//
//  DIWrapper.swift
//  FeedReader
//
//  Created by Stan Gajda on 24/05/2023.
//

import Foundation

// MARK: - Injected
@propertyWrapper public struct Injected<Service> {
    private var service: Service

    public init() {
        self.service = Injection.resolver.resolve(Service.self)
    }

    public init(name: Injection.Name? = nil) {
        self.service = Injection.resolver.resolve(
            Service.self, name: name?.rawValue) ?? Injection.resolver.resolve(Service.self)
    }

    public init<ARG1>(_ argument1: ARG1) {
        self.service = Injection.resolver.resolve(
            Service.self, argument: argument1) ?? Injection.resolver.resolve(Service.self)
    }

    public init<ARG1, ARG2>(_ argument1: ARG1, _ argument2: ARG2) {
        self.service = Injection.resolver.resolve(
            Service.self, arguments: argument1, argument2) ?? Injection.resolver.resolve(Service.self)
    }

    public init<ARG1, ARG2, ARG3>(_ argument1: ARG1, _ argument2: ARG2, _ argument3: ARG3) {
        self.service = Injection.resolver.resolve(
            Service.self, arguments: argument1, argument2, argument3) ?? Injection.resolver.resolve(Service.self)
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
