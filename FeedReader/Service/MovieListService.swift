//
//  MovieList.swift
//  FeedReader
//
//  Created by Stan Gajda on 02/08/2021.
//

import Foundation
import Combine

protocol MovieListServiceProtocol {
    func fetchMovies(_ request: URLRequest) -> AnyPublisher<Movies, Error>
}

struct MovieListService: MovieListServiceProtocol{
    var service: ServiceProtocol = Service()
    func fetchMovies(_ request: URLRequest) -> AnyPublisher<Movies, Error>{
        return self.service.fetchData(request)
            .subscribe(on: DispatchQueue(label: Config.Queue.MovieList.label, qos: Config.Queue.MovieList.qos))
            .eraseToAnyPublisher()
    }
}
