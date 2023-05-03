//
//  LoadableViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 19/07/2021.
//

import Foundation
import Combine

//protocol StateProtocol: ObservableObject, LoadableProtocol {
//    associatedtype T
//    var state: T { get set }
//}
//
//extension StateProtocol {
//    func assignNoRetain<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, T>, on root: Root) -> AnyCancellable {
//        self.publishersSystem(state)
//                        .assignNoRetain(to: keyPath, on: self)
//    }
//}


protocol LoadableProtocol {
    associatedtype T
    associatedtype U
    var input: PassthroughSubject<Action, Never> { get }
    var fetch: AnyPublisher<T, Error> { get }
}

extension LoadableProtocol {
    typealias State = LoadableEnums<T,U>.State
    typealias Action = LoadableEnums<T,U>.Action
    
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

    func assignToState<Root: AnyObject>(_ state: State, _ self: Root, to keyPath: ReferenceWritableKeyPath<Root, State>) -> AnyCancellable {
            publishersSystem(state)
                .assignNoRetain(to: keyPath, on: self)
    }
    
    private func onStateChanged() -> Feedback<State, Action> {
        Feedback { (state: State) -> AnyPublisher<Action, Never> in
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }
            return self.fetch
                .map(
                    Action.onLoaded
                )
                .catch { error in
                    Just(Action.onFailedLoaded(error))
                }
                .eraseToAnyPublisher()
        }
    }
    
    private func userInput(input: AnyPublisher<Action, Never>) -> Feedback<State, Action> {
        Feedback { _ in
            input
        }
       
    }
}
