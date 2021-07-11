//
//  Service.swift
//  FeedReader
//
//  Created by Stan Gajda on 17/06/2021.
//

import Foundation
import Combine
import UIKit

class MoviesService: ObservableObject{
    @Published var movies: Array<MovieDetail>?
    
    let service = Service()
    var cancellable: AnyCancellable?
    let request = APIRequest["Top250Movies"].get()
    
    init(){
    
    }
    
    func loadMovies(){
        cancellable = service.fetchMovies(request)
            .sinkToResult({ result in
            switch result{
                case .success(let data):
                    self.movies = data.items
                    break
                case .failure(_):
                    break
                }
            })
    }
}

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
            }.eraseToAnyPublisher()
    }
    
    func fetchData<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        fetchData(request)
            .receive(on: DispatchQueue.main)
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
    
    func fetchMovies(_ request: URLRequest) -> AnyPublisher<Movies, Error>{
        return self.fetchData(request)
    }
}
