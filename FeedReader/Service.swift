//
//  Service.swift
//  FeedReader
//
//  Created by Stan Gajda on 17/06/2021.
//

import Foundation
import Combine
import UIKit

struct Service{
    var session: URLSession = .shared
    var cancellable: AnyCancellable?
    
    func fetchImage(_ request: URLRequest) -> AnyPublisher<UIImage, Error> {
        fetchData(request)
            .tryMap { data in
                try data.toImage(request)
            }.eraseToAnyPublisher()
    }
    
    func fetchData<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        fetchData(request)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchData(_ request: URLRequest) -> AnyPublisher<Data, Error> {
        return self.session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                try response.mapError(data)
            }
            .mapUnderlyingError()
            .eraseToAnyPublisher()
    }
    
    func fetchMovies(request: URLRequest) -> AnyPublisher<Movies, Error>{
        return self.fetchData(request)
    }
}
