//
//  DIExtensions.swift
//  FeedReader
//
//  Created by Stan Gajda on 24/05/2023.
//

import Foundation
import Swinject

//MARK:- Injection
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
    func resolve<Service>(_ serviceType: Service.Type) -> Service {
        guard let resolve = resolve(serviceType, name: nil) else {
            fatalError("Can not find Service \(serviceType) ")
        }
        return resolve
    }
}
