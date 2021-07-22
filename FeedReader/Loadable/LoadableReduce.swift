//
//  LoadableReduce.swift
//  FeedReader
//
//  Created by Stan Gajda on 22/07/2021.
//

import Foundation

extension Loadable {
    func reduce(_ state: State, _ action: Action) -> State {
        switch state {
        case .start:
            switch action {
            case .onAppear:
                return .loading
            default:
                return state
            }
        case .loading:
            switch action {
            case .onFailedLoaded(let error):
                return .failedLoaded(error)
            case .onLoaded(let movies):
                return .loaded(movies)
            default:
                return state
            }
        case .loaded:
            return state
        case .failedLoaded:
            return state
        }
    }
}
