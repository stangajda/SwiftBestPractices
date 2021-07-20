//
//  MovieDetailViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//

import Combine

final class MovieDetailViewModel: LoadableViewModel<MovieDetailViewModel.MovieDetailItem>, ObservableObject{
    @Published private(set) var state = State.start
    var movieList: MoviesListViewModel.MovieItem
    
    let service = Service()
    private var cancellableStorage = Set<AnyCancellable>()
    
    init(movieList: MoviesListViewModel.MovieItem){
        self.movieList = movieList
        super.init()
        self.publishersSystem(state)
        .assign(to: \.state, on: self)
        .store(in: &cancellableStorage)
    }
    
    override func fetch() -> AnyPublisher<MovieDetailViewModel.MovieDetailItem, Error>{
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
