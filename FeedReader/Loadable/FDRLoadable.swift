//
//  LoadableViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 19/07/2021.
//

import Foundation
import Combine

protocol FDRLoadable {
    associatedtype T
    associatedtype U
    var input: PassthroughSubject<Action, Never> { get }
    var fetch: AnyPublisher<T, Error> { get }
}

extension FDRLoadable {
    typealias State = FDRLoadableEnums<T,U>.State
    typealias Action = FDRLoadableEnums<T,U>.Action
    
    func publishersSystem(_ state: State) -> AnyPublisher<State, Never> {
        Publishers.system(
            initial: state,
            reduce: self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                self.onStateChanged(),
                self.userInput(input: input.eraseToAnyPublisher())
            ]
        )
    }
    
    func send(action: Action) {
        input.send(action)
    }
    
    private func onStateChanged() -> FDRFeedback<State, Action> {
        FDRFeedback { (state: State) -> AnyPublisher<Action, Never> in
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }
            return self.fetch
                .map(Action.onLoaded)
                .catch { error in
                    Just(Action.onFailedLoaded(error))
                }
                .eraseToAnyPublisher()
        }
    }
    
    private func userInput(input: AnyPublisher<Action, Never>) -> FDRFeedback<State, Action> {
        FDRFeedback { _ in input }
    }
}
