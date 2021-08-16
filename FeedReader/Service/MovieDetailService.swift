//
//  MovieDetailService.swift
//  FeedReader
//
//  Created by Stan Gajda on 02/08/2021.
//

import Foundation
import Combine
import Resolver

protocol MovieDetailServiceInterface {
    func fetchMovieDetail(_ request: URLRequest) -> AnyPublisher<MovieDetail, Error>
}

struct MovieDetailService: MovieDetailServiceInterface{
    @Injected var service: ServiceInterface
    func fetchMovieDetail(_ request: URLRequest) -> AnyPublisher<MovieDetail, Error>{
        return self.service.fetchData(request)
    }
}
