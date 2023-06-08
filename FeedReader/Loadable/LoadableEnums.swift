//
//  LoadableEnums.swift
//  FeedReader
//
//  Created by Stan Gajda on 22/07/2021.
//

import Foundation

struct LoadableEnums<T,U>{
    enum State: Equatable {
        case start(U? = nil)
        case loading(U? = nil)
        case loaded(T)
        case failedLoaded(Error)
        static func == (lhs: LoadableEnums<T, U>.State, rhs: LoadableEnums<T, U>.State) -> Bool {
            switch (lhs, rhs) {
            case (.start, .start):
                return true
            case (.loading, .loading):
                return true
            case (.loaded, .loaded):
                return true
            case (.failedLoaded, .failedLoaded):
                return true
            default:
                return false
            }
        }
    }
    enum Action {
        case onAppear
        case onLoaded(T)
        case onFailedLoaded(Error)
        case onReset
    }
}
