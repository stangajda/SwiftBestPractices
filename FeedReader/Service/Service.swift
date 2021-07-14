//
//  Service.swift
//  FeedReader
//
//  Created by Stan Gajda on 17/06/2021.
//

import Combine
import UIKit

struct Service{
    var session: URLSession = .shared
    var cancellable: AnyCancellable?
    
    init(session: URLSession = .shared){
        self.session = session
    }
    
    func fetchImage(_ request: URLRequest) -> AnyPublisher<UIImage, Error> {
        fetchData(request)
            .tryMap { data in
                try data.toImage(request)
            }
            .eraseToAnyPublisher()
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
            .receive(on: DispatchQueue.main)
            .mapUnderlyingError()
            .eraseToAnyPublisher()
    }
    
    func fetchMovies(_ request: URLRequest) -> AnyPublisher<Movies, Error>{
        return self.fetchData(request)
    }
    
    func fetchMovieDetail(_ request: URLRequest) -> AnyPublisher<MovieDetail, Error>{
        return self.fetchData(request)
    }
}
