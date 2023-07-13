//
//  MockMovieListService.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 12/07/2023.
//

import Foundation
import Combine
import UIKit

struct MockMovieListService: MovieListServiceProtocol {
    var result: Result<Movies, Error>
    
    init(_ result: Result<Movies, Error>) {
        self.result = result
    }
    
    func fetchMovies(_ request: URLRequest) -> AnyPublisher<Movies, Error> {
        return result.publisher.eraseToAnyPublisher()
    }
}

struct MockMovieDetailService: MovieDetailServiceProtocol {
    var result: Result<MovieDetail, Error>
    
    init(_ result: Result<MovieDetail, Error>) {
        self.result = result
    }
    
    func fetchMovieDetail(_ request: URLRequest) -> AnyPublisher<MovieDetail, Error> {
        return result.publisher.eraseToAnyPublisher()
    }
}

struct MockImageService: ImageServiceProtocol {
    var result: Result<UIImage, Error>
    
    init(_ result: Result<UIImage, Error>) {
        self.result = result
    }
    
    func fetchImage(_ request: URLRequest) -> AnyPublisher<UIImage, Error> {
        return result.publisher.eraseToAnyPublisher()
    }
}
