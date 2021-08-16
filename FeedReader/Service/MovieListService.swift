//
//  MovieList.swift
//  FeedReader
//
//  Created by Stan Gajda on 02/08/2021.
//

import Foundation
import Combine
import Resolver

protocol MovieListServiceInterface {
    func fetchMovies(_ request: URLRequest) -> AnyPublisher<Movies, Error>
}

struct MovieListService: MovieListServiceInterface{
    @Injected var service: ServiceInterface
    func fetchMovies(_ request: URLRequest) -> AnyPublisher<Movies, Error>{
        return self.service.fetchData(request)
    }
}
