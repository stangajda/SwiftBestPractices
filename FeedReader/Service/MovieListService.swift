//
//  MovieList.swift
//  FeedReader
//
//  Created by Stan Gajda on 02/08/2021.
//

import Foundation
import Combine
import Resolver

protocol MovieListServiceProtocol {
    func fetchMovies(_ request: URLRequest) -> AnyPublisher<Movies, Error>
}

struct MovieListService: MovieListServiceProtocol{
    @Injected var service: ServiceProtocol
    func fetchMovies(_ request: URLRequest) -> AnyPublisher<Movies, Error>{
        return self.service.fetchData(request)
    }
}
