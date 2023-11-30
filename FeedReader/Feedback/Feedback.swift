//
//  Feedback.swift
//  FeedReader
//
//  Created by Stan Gajda on 17/07/2021.
//

import Combine

struct Feedback<State, Action> {
    let run: (AnyPublisher<State, Never>) -> AnyPublisher<Action, Never>
}

extension Feedback {
    init<Effect: Publisher>(effects: @escaping (State) -> Effect)
        where Effect.Output == Action, Effect.Failure == Never {
        self.run = { state -> AnyPublisher<Action, Never> in
            state
                .map { item in
                    effects(item) }
                .switchToLatest()
                .eraseToAnyPublisher()
        }
    }
}
