//
//  MoviesListViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//
import Foundation
import Combine

class MoviesListViewModel: ObservableObject{
    @Published private(set) var state = State.start
    private let service = Service()
    private var cancellableStorage = Set<AnyCancellable>()
    private let input = PassthroughSubject<Action, Never>()
    
    init() {
        Publishers.system(
            initial: state,
            reduce: self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                self.onStateChanged(),
                self.userInput(input: input.eraseToAnyPublisher())
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &cancellableStorage)
    }
    
    deinit {
        cancellableStorage.removeAll()
    }
    
    func send(action: Action) {
        input.send(action)
    }
}

extension MoviesListViewModel{
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

extension MoviesListViewModel {
    enum State {
        case start
        case loading
        case loaded(Array<MovieItem>)
        case failedLoaded(Error)
    }
    
    enum Action {
        case onAppear
        case onSelectMovie(Int)
        case onMoviesLoaded(Array<MovieItem>)
        case onFailedToLoadMovies(Error)
    }
    
    func reduce(_ state: State, _ event: Action) -> State {
        switch state {
        case .start:
            switch event {
            case .onAppear:
                return .loading
            default:
                return state
            }
        case .loading:
            switch event {
            case .onFailedToLoadMovies(let error):
                return .failedLoaded(error)
            case .onMoviesLoaded(let movies):
                return .loaded(movies)
            default:
                return state
            }
        case .loaded:
            return state
        case .failedLoaded:
            return state
        }
    }
    
    func onStateChanged() -> Feedback<State, Action> {
        Feedback { (state: State) -> AnyPublisher<Action, Never> in
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }
            return self.loadMovies()
                .map(Action.onMoviesLoaded)
                .catch { error in
                    Just(Action.onFailedToLoadMovies(error))
                }
                .eraseToAnyPublisher()
        }
    }
    
    func userInput(input: AnyPublisher<Action, Never>) -> Feedback<State, Action> {
        Feedback { _ in input }
    }
}

extension MoviesListViewModel{
    func loadMovies() -> AnyPublisher<Array<MoviesListViewModel.MovieItem>, Error>{
        let request = APIRequest["trending/movie/day"].get()
        return self.service.fetchMovies(request)
            .map { item in
                item.results.map(MovieItem.init)
            }
            .eraseToAnyPublisher()
    }
}
