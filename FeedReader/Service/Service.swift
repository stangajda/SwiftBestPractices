//
//  Service.swift
//  FeedReader
//
//  Created by Stan Gajda on 17/06/2021.
//

import Combine
import Resolver
import UIKit

protocol URLSessionProtocol {
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher

}

extension URLSession: URLSessionProtocol {
    
}

protocol ServiceProtocol {
    func fetchData<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error>
    func fetchData(_ request: URLRequest) -> AnyPublisher<Data, Error>
}

struct Service: ServiceProtocol{
    var session: URLSessionProtocol = DependencyManager.shared.container.resolve(URLSessionProtocol.self)!
    
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

}
