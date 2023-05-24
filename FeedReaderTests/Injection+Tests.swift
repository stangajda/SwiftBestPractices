//
//  Resolver+Tests.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 23/07/2021.
//

import Foundation
import Swinject

extension TestInjection {
    func setupTestURLSession() {
        assembler.apply(assembly: MockNetworkAssembly())
    }
}

fileprivate class MockNetworkAssembly: Assembly {
    func assemble(container: Container) {
        container.register(URLSessionProtocol.self) { _ in
            URLSession.mockURLSession()
        }.inObjectScope(.container)
    }
}
