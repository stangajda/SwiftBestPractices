//
//  MockMovieDetailService.swift
//  FeedReader
//
//  Created by Stan Gajda on 13/07/2023.
//

import Foundation
import Combine

struct MockMovieDetailService: MovieDetailServiceProtocol {
    private static var result: Result<MovieDetail, Error>?

    init() {
    }

    init(_ result: Result<MovieDetail, Error>) {
        Self.result = result
    }

    func fetchMovieDetail(_ request: URLRequest) -> AnyPublisher<MovieDetail, Error> {
        guard let result = Self.result else {
            return Empty().eraseToAnyPublisher()
        }
        return result.publisher.eraseToAnyPublisher()
    }
}
