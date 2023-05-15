//
//  MoviesListViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//

import Foundation
import Combine
import Resolver

protocol MoviesListViewModelProtocol: ObservableLoadableProtocol where T == Array<MoviesListViewModel.MovieItem>, U == Any {
   
}


final class MoviesListViewModel: MoviesListViewModelProtocol {
    @Published var state = State.start()
    @Injected private var service: MovieListServiceProtocol
    
    typealias T = Array<MoviesListViewModel.MovieItem>
    typealias U = Any
    
    var input = PassthroughSubject<Action, Never>()
    
    private var cancelable: AnyCancellable?
    
    init() {
        cancelable = self.assignNoRetain(self, to: \.state)
    }
    
    deinit {
        reset()
    }
    
    lazy var reset: () -> Void = { [weak self] in
        self?.input.send(.onReset)
        self?.cancelable?.cancel()
    }
    
}

extension MoviesListViewModel: LoadableProtocol{
    var fetch: AnyPublisher<Array<MoviesListViewModel.MovieItem>, Error>{
        
        guard let url = APIUrlBuilder[TrendingPath()] else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return self.service.fetchMovies(URLRequest(url: url).get())
            .map { item in
                item.results.map(MoviesListViewModel.MovieItem.init)
            }
            .eraseToAnyPublisher()
    }
}

extension MoviesListViewModel {
    struct MovieItem: Identifiable, Hashable {
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

class AnyMoviesListViewModelProtocol: MoviesListViewModelProtocol {
    typealias ViewModel = MoviesListViewModel
    typealias T = Array<MoviesListViewModel.MovieItem>
    
    @Published var state: ViewModel.State
    var input: PassthroughSubject<ViewModel.Action, Never>
    var fetch: AnyPublisher<T, Error>

    private var cancellable: AnyCancellable?
    init<ViewModel: MoviesListViewModelProtocol>(_ viewModel: ViewModel) {
        state = viewModel.state
        input = viewModel.input
        fetch = viewModel.fetch
        cancellable = self.assignNoRetain(self, to: \.state)
    }
}


