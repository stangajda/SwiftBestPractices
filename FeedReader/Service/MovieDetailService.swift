//
//  MovieDetailService.swift
//  FeedReader
//
//  Created by Stan Gajda on 02/08/2021.
//

import Foundation
import Combine

protocol MovieDetailServiceProtocol {
    func fetchMovieDetail(_ request: URLRequest) -> AnyPublisher<MovieDetail, Error>
}

struct MovieDetailService: MovieDetailServiceProtocol{
    @InjectedSwinject var service: ServiceProtocol
    func fetchMovieDetail(_ request: URLRequest) -> AnyPublisher<MovieDetail, Error>{
        return self.service.fetchData(request)
    }
}
