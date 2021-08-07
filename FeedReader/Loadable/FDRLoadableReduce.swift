//
//  FDRLoadableReduce.swift
//  FeedReader
//
//  Created by Stan Gajda on 22/07/2021.
//

import Foundation

extension FDRLoadableProtocol {
    func reduce(_ state: State, _ action: Action) -> State {
        switch state {
        case .start(let id):
            switch action {
            case .onAppear:
                return .loading(id)
            default:
                return state
            }
        case .loading:
            switch action {
            case .onFailedLoaded(let error):
                return .failedLoaded(error)
            case .onLoaded(let result):
                return .loaded(result)
            case .onReset:
                return .start()
            default:
                return state
            }
        case .loaded:
            switch action {
            case .onReset:
                return .start()
            default:
                return state
            }
        case .failedLoaded:
            switch action {
            case .onReset:
                return .start()
            default:
                return state
            }
        }
    }
}
