//
//  Resolver+Tests.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 23/07/2021.
//

import Foundation
import Resolver

extension Resolver {
  static var mock = Resolver(parent: .main)
    static func registerMockServices() {
        root = Resolver.mock
        defaultScope = .application
        Resolver.mock.register { URLSession.mockURLSession }
        Resolver.mock.register { FDRService() as FDRServiceInterface}
    }
}
