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
    @Published private(set) var state = State.start()
    @Injected private var service: MovieListServiceProtocol
    
    typealias T = Array<MoviesListViewModel.MovieItem>
    typealias U = Any
    
    var input = PassthroughSubject<Action, Never>()
    
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

extension MoviesListViewModel: LoadableProtocol{
    var fetch: AnyPublisher<T, Error>{
        let url = APIUrlBuilder[TrendingPath()]
        
        guard let url = url else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return self.service.fetchMovies(URLRequest(url: url).get())
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
        let vote_average: Double
        let vote_count: Int
        init(_ movie: Movie) {
            id = movie.id
            title = movie.title
            poster_path = movie.poster_path
            vote_average = movie.vote_average.halfDivide()
            vote_count = movie.vote_count
        }
    }
}
