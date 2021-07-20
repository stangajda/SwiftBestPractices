//
//  MoviesListViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//

import Foundation
import Combine

final class MoviesListViewModel: LoadableViewModel<Array<MoviesListViewModel.MovieItem>>, ObservableObject{
    @Published private(set) var state = State.start
    private let service = Service()
    private var cancellableStorage = Set<AnyCancellable>()
    
    override init() {
        super.init()
        self.publishersSystem(state)
        .assign(to: \.state, on: self)
        .store(in: &cancellableStorage)
    }
    
    struct MovieItem: Identifiable {
        let id: Int
        let title: String
        let poster_path: String
        
        init(_ movie: Movie) {
            id = movie.id
            title = movie.title
            poster_path = movie.poster_path
        }
    }
    
    override func fetch() -> AnyPublisher<Array<MoviesListViewModel.MovieItem>, Error>{
        let request = APIRequest["trending/movie/day"].get()
        return self.service.fetchMovies(request)
            .map { item in
                item.results.map(MovieItem.init)
            }
            .eraseToAnyPublisher()
    }
    
}
