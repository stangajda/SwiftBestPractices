//
//  Feedback.swift
//  FeedReader
//
//  Created by Stan Gajda on 17/07/2021.
//

import Combine

struct Feedback<State, Event> {
    let run: (AnyPublisher<State, Never>) -> AnyPublisher<Event, Never>
}

extension Feedback {
    init<Effect: Publisher>(effects: @escaping (State) -> Effect) where Effect.Output == Event, Effect.Failure == Never {
        self.run = { state -> AnyPublisher<Event, Never> in
            state
                .map { item in
                    effects(item) }
                .switchToLatest()
                .eraseToAnyPublisher()
        }
    }
}
