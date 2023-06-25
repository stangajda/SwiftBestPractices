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
    init(){
        injectDependency()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    func injectDependency(){
        Injection.main.initialRegistration()
    }

}
