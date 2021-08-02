//
//  FDRService.swift
//  FeedReader
//
//  Created by Stan Gajda on 17/06/2021.
//

import Combine
import Resolver
import UIKit

struct FDRService{
    @Injected var session: URLSession
    var cancellable: AnyCancellable?
    
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
