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
    @Published var movies: Array<Movie>?
    
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
                case .failure(let error):
                    Helper.printLog(error)
                    break
                }
            })
    }
}

class MovieDetailService: ObservableObject{
    @Published var movieDetail: MovieDetail?
    
    let service = Service()
    var cancellable: AnyCancellable?
    
    init(){
    }
    
    func loadMovies(id: String){
        
        let request = APIRequest["Title", id, "Images"]
        cancellable = service.fetchMovieDetail(request)
            .sinkToResult({ result in
            switch result{
                case .success(let movieDetail):
                    self.movieDetail = movieDetail
                    break
                case .failure(let error):
                    Helper.printLog(error)
                    break
                }
            })
    }
}

class ImageService: ObservableObject{
    @Published var image: UIImage?
    
    let service = Service()
    var cancellable: AnyCancellable?
    
    init(){
    }
    
    func loadImage(_ urlString: String){
        let request = URLRequest(url: URL(string: urlString)!).get()
        cancellable = service.fetchImage(request)
            .sinkToResult({ result in
            switch result{
                case .success(let image):
                    self.image = image
                    break
                case .failure(let error):
                    Helper.printLog(error)
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
