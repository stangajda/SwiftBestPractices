//
//  DIExtensions.swift
//  FeedReader
//
//  Created by Stan Gajda on 24/05/2023.
//

import Foundation
import Swinject

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

extension Container {
    func resolve<Service, Arg1, Arg2, Arg3>(
        _ serviceType: Service.Type,
        arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3
    ) -> Service {
        guard let resolve = resolve(serviceType, name: nil, arguments: arg1, arg2, arg3) else {
            fatalError("Can not find Service \(serviceType) with arguments \(arg1), \(arg2), \(arg3)")
        }
        return resolve
    }
    public func resolve<Service, Arg1>(
        _ serviceType: Service.Type,
        argument: Arg1
    ) -> Service {
        guard let resolve = resolve(serviceType, name: nil, argument: argument) else {
            fatalError("Can not find Service \(serviceType) with argument \(argument)")
        }
        return resolve
    }
    func resolve<Service>(_ serviceType: Service.Type) -> Service {
        guard let resolve = resolve(serviceType, name: nil) else {
            fatalError("Can not find Service \(serviceType) ")
        }
        return resolve
    }
    func resolve<Service>(_ serviceType: Service.Type, name: String?) -> Service {
        guard let resolve = resolve(serviceType, name: nil) else {
            fatalError("Can not find Service \(serviceType) ")
        }
        return resolve
    }
}
