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
        public init(stringLiteral: String) {
            self.rawValue = stringLiteral
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
