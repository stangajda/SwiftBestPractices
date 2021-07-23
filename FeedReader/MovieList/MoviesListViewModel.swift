//
//  MoviesListViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//

import Foundation
import Combine
import Resolver

class MoviesListViewModel: ObservableObject{
    @Published private(set) var state = State.start
    var input = PassthroughSubject<Action, Never>()
    typealias T = Array<MoviesListViewModel.MovieItem>
    private let service = Service()
    private var cancellableStorage = Set<AnyCancellable>()
    
    init() {
        self.publishersSystem(state)
        .assign(to: \.state, on: self)
        .store(in: &cancellableStorage)
    }
    
    deinit {
        cancellableStorage.removeAll()
    }
    
}

extension MoviesListViewModel: Loadable{
    var fetch: AnyPublisher<T, Error>{
        let request = APIRequest["trending/movie/day"].get()
        return self.service.fetchMovies(request)
            .map { item in
                item.results.map(MovieItem.init)
            }
            .eraseToAnyPublisher()
    }
}

extension MoviesListViewModel {
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
}
