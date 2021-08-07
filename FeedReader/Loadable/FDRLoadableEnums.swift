//
//  LoadableEnums.swift
//  FeedReader
//
//  Created by Stan Gajda on 22/07/2021.
//

import Foundation

struct FDRLoadableEnums<T,U>{
    enum State {
        case start(U? = nil)
        case loading(U? = nil)
        case loaded(T)
        case failedLoaded(Error)
    }
    enum Action {
        case onAppear
        case onLoaded(T)
        case onFailedLoaded(Error)
        case onReset
    }
}
