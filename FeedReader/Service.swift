//
//  Service.swift
//  FeedReader
//
//  Created by Stan Gajda on 17/06/2021.
//

import Foundation
import Combine

struct Service{
    var session: URLSession = .shared
    var cancellable: AnyCancellable?
    
    func fetchData<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        fetchData(request: request)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchData(request: URLRequest) -> AnyPublisher<Data, Error> {
//        let request = URLRequest(url: url)

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
