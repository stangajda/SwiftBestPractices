//
//  MockStateProtocol.swift
//  FeedReader
//
//  Created by Stan Gajda on 16/05/2023.
//

import Foundation

protocol MockStateProtocol {
    var mockState: MockState.State { get }
}

struct MockState {
    enum State {
        case start
        case loading
        case loaded
        case failedLoaded
    }
}
