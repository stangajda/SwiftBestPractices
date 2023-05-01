//
//  MoviesListViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//

import Foundation
import Combine
import Resolver

protocol MoviesListViewModelProtocol: ObservableObject, LoadableProtocol {
    var state: MoviesListViewModel.State { get }
    var input: PassthroughSubject<MoviesListViewModel.Action, Never> { get }
    var fetch: AnyPublisher<Array<MoviesListViewModel.MovieItem>, Error> { get }
}


class MoviesListViewModel: MoviesListViewModelProtocol {
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
    var fetch: AnyPublisher<Array<MoviesListViewModel.MovieItem>, Error>{
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

class MoviesListViewModelWrapper: MoviesListViewModelProtocol {
    @Published var state: MoviesListViewModel.State
    private let _input: () -> PassthroughSubject<MoviesListViewModel.Action, Never>
    private let _fetch: () -> AnyPublisher<Array<MoviesListViewModel.MovieItem>, Error>

    private var cancellable: AnyCancellable?
    init<MoviesListViewModel: MoviesListViewModelProtocol>(_ viewModel: MoviesListViewModel) {
        state = viewModel.state
        _input = { viewModel.input }
        _fetch = { viewModel.fetch }
        cancellable = self.publishersSystem(state)
                        .assignNoRetain(to: \.state, on: self)
    }

    var input: PassthroughSubject<MoviesListViewModel.Action, Never> {
        return _input()
    }

    var fetch: AnyPublisher<Array<MoviesListViewModel.MovieItem>, Error> {
        return _fetch()
    }
}

