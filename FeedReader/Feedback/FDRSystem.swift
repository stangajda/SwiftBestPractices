//
//  System.swift
//  FeedReader
//
//  Created by Stan Gajda on 17/07/2021.
//

import Combine

extension Publishers {
    
    static func system<State, Action, Scheduler: Combine.Scheduler>(
        initial: State,
        reduce: @escaping (State, Action) -> State,
        scheduler: Scheduler,
        feedbacks: [FDRFeedback<State, Action>]
    ) -> AnyPublisher<State, Never> {
        let state = CurrentValueSubject<State, Never>(initial)
        let events = feedbacks.map { feedback in
                                        feedback.run(state.eraseToAnyPublisher())
        }
        return Deferred {
            Publishers.MergeMany(events)
                .receive(on: scheduler)
                .scan(initial, reduce)
                .handleEvents(receiveOutput: state.send)
                .receive(on: scheduler)
                .prepend(initial)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
