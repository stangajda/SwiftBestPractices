//
//  LoadableEnums.swift
//  FeedReader
//
//  Created by Stan Gajda on 22/07/2021.
//

import Foundation

struct FDRLoadableEnums<T>{
    enum State {
        case start(T? = nil)
        case loading(T? = nil)
        case loaded(T)
        case failedLoaded(Error)
    }
    enum Action {
        case onAppear
        case onLoaded(T)
        case onFailedLoaded(Error)
    }
}
