//
//  FDRMoviesListViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//

import Foundation
import Combine
import Resolver

class FDRMoviesListViewModel: ObservableObject{
    @Published private(set) var state = State.start()
    var input = PassthroughSubject<Action, Never>()
    typealias T = Array<FDRMoviesListViewModel.MovieItem>
    typealias U = Any
    private let service: FDRMovieListServiceInterface = FDRMovieListService()
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = self.publishersSystem(state)
                        .assignNoRetain(to: \.state, on: self)
    }
    
    deinit {
        cancel()
    }
    
    func cancel(){
        cancellable?.cancel()
    }
    
}

extension FDRMoviesListViewModel: FDRLoadable{
    var fetch: AnyPublisher<T, Error>{
        let request = FDRAPIRequest["trending/movie/day"].get()
        return self.service.fetchMovies(request)
            .map { item in
                item.results.map(MovieItem.init)
            }
            .eraseToAnyPublisher()
    }
}

extension FDRMoviesListViewModel {
    struct MovieItem: Identifiable {
        let id: Int
        let title: String
        let poster_path: String
        
        init(_ movie: FDRMovie) {
            id = movie.id
            title = movie.title
            poster_path = movie.poster_path
        }
    }
}
