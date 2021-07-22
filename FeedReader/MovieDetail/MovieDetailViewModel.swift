//
//  MovieDetailViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//
import Foundation
import Combine

final class MovieDetailViewModel: ObservableObject{
    @Published private(set) var state: State = State.start
    var input = PassthroughSubject<Action, Never>()
    var movieList: MoviesListViewModel.MovieItem
    let service = Service()
    private var cancellableStorage = Set<AnyCancellable>()
    
    typealias T = MovieDetailViewModel.MovieDetailItem
    
    init(movieList: MoviesListViewModel.MovieItem){
        self.movieList = movieList
        self.publishersSystem(state)
        .assign(to: \.state, on: self)
        .store(in: &cancellableStorage)
    }
    
    deinit {
        cancellableStorage.removeAll()
    }
}

extension MovieDetailViewModel: Loadable {
    var fetch: AnyPublisher<T, Error> {
        let request = APIRequest["movie/" + String(self.movieList.id)]
        return self.service.fetchMovieDetail(request)
            .map { item in
                MovieDetailItem(item)
            }
            .eraseToAnyPublisher()
    }
}

extension MovieDetailViewModel{
    struct MovieDetailItem {
        let id: Int
        let title: String
        let overview: String
        let backdrop_path: String
        
        init(_ movie: MovieDetail) {
            id = movie.id
            title = movie.title
            overview = movie.overview
            backdrop_path = movie.backdrop_path
        }
    }
}
