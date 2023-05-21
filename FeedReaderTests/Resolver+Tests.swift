//
//  Resolver+Tests.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 23/07/2021.
//

import Foundation
import Resolver

extension Resolver {
    static var mock = Resolver(child: .main)
    static func registerMockServices() {
        root = Resolver.mock
        defaultScope = .application
        Resolver.mock.register { URLSession.mockURLSession() as URLSessionProtocol}
        Resolver.mock.register { Service() as ServiceProtocol}
        Resolver.mock.register { MovieListService() as MovieListServiceProtocol}
        Resolver.mock.register { ImageService() as ImageServiceProtocol}
        //Resolver.mock.register { URLSession.mockURLSession() }
    }
}
