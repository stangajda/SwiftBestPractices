//
//  PrewievSnapshot.swift
//  FeedReader
//
//  Created by Stan Gajda on 30/01/2024.
//

import Foundation
import PreviewSnapshots

public extension PreviewSnapshots<Any>.Configuration {
    init() {
        self.init(name: String(), state: String())
    }
    init(named name: Injection.Name) {
        self.init(name: name.rawValue, state: String())
    }
}

public extension PreviewSnapshots.Configuration {
    init(named name: Injection.Name, state: State) {
        self.init(name: name.rawValue, state: state)
    }
}
