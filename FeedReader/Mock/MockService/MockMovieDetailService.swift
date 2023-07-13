//
//  MockMovieDetailService.swift
//  FeedReader
//
//  Created by Stan Gajda on 13/07/2023.
//

import Foundation
import Combine

struct MockMovieDetailService: MovieDetailServiceProtocol {
    fileprivate static var result: Result<MovieDetail, Error> = .success(MovieDetail.mock)
    
    static func mockResult(_ result: Result<MovieDetail, Error>) {
        Self.result = result
    }
    
    func fetchMovieDetail(_ request: URLRequest) -> AnyPublisher<MovieDetail, Error> {
        return Self.result.publisher.eraseToAnyPublisher()
    }
}
