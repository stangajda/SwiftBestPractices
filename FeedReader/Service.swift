//
//  Service.swift
//  FeedReader
//
//  Created by Stan Gajda on 17/06/2021.
//

import Foundation
import Combine

struct Service{
    
    var cancellable: AnyCancellable?
    var session: URLSession = .shared

    init(session: URLSession = .shared){
        self.session = session
    }
    
    func fetchData<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
        fetchData(url: url)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    
    func fetchData(url: URL) -> AnyPublisher<Data, Error> {
        let request = URLRequest(url: url)

        return self.session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                try response.mapError(data)
            }
            .eraseToAnyPublisher()
    }
    
}
