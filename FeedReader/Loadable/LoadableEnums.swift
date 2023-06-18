//
//  LoadableEnums.swift
//  FeedReader
//
//  Created by Stan Gajda on 22/07/2021.
//

import Foundation

struct LoadableEnums<T: Equatable, U:Equatable>{
    enum State: Equatable {
        case start(U? = nil)
        case loading(U? = nil)
        case loaded(T)
        case failedLoaded(Error)
        static func == (lhs: LoadableEnums<T, U>.State, rhs: LoadableEnums<T, U>.State) -> Bool {
            switch (lhs, rhs) {
            case (.start(let lhsValue), .start(let rhsValue)):
                return lhsValue == rhsValue
            case (.loading(let lhsValue), .loading(let rhsValue)):
                return lhsValue == rhsValue
            case (.loaded(let lhsValue), .loaded(let rhsValue)):
                return lhsValue == rhsValue
            case (.failedLoaded(let lhsValue), .failedLoaded(let rhsValue)):
                return lhsValue.localizedDescription == rhsValue.localizedDescription
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
