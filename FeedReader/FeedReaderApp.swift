//
//  FeedReaderApp.swift
//  FeedReader
//
//  Created by Stan Gajda on 16/06/2021.
//

import SwiftUI
import Combine

@main
struct FeedReaderApp: App {
    init() {
        injectDependency()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    func injectDependency() {

        if Config.Testing.isRunningTests {
            Injection.main.mockViewModel()
            return
        }

#if MOCK
        Injection.main.mockViewModel()
#else
        Injection.main.initialRegistration()
#endif
    }
}
