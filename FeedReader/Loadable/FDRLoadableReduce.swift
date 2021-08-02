//
//  FDRLoadableReduce.swift
//  FeedReader
//
//  Created by Stan Gajda on 22/07/2021.
//

import Foundation

extension FDRLoadable {
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
            case .onLoaded(let result):
                return .loaded(result)
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
