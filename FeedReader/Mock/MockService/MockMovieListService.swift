//
//  MockMovieListService.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 12/07/2023.
//

import Foundation
import Combine

struct MockMovieListService: MovieListServiceProtocol {
    private static var result: Result<Movies, Error>? = nil
    
    init(){
    }
    
    init(_ result: Result<Movies, Error>) {
        Self.result = result
    }
    
    func fetchMovies(_ request: URLRequest) -> AnyPublisher<Movies, Error> {
        guard let result = Self.result else {
            return Empty().eraseToAnyPublisher()
        }
        return result.publisher.eraseToAnyPublisher()
    }
}
