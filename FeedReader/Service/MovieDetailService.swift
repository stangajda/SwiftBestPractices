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

struct MovieDetailService: MovieDetailServiceProtocol {
    @Injected var service: ServiceProtocol
    fileprivate let queue = DispatchQueue(label: Config.QueueMovieDetail.label, qos: Config.QueueMovieDetail.qos)
    func fetchMovieDetail(_ request: URLRequest) -> AnyPublisher<MovieDetail, Error> {
        return self.service.fetchData(request)
            .subscribe(on: queue)
            .eraseToAnyPublisher()
    }
}
