//
//  MoviesListViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//
import Foundation
import Combine

class LoadableViewModel<T>{
    
    private let input = PassthroughSubject<Action, Never>()
    
    func publishersSystem(_ state: State) -> AnyPublisher<State, Never> {
        Publishers.system(
            initial: state,
            reduce: self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                self.onStateChanged(),
                self.userInput(input: input.eraseToAnyPublisher())
            ]
        )
    }
    
    func send(action: Action) {
        input.send(action)
    }
    
    func onStateChanged() -> Feedback<State, Action> {
        Feedback { (state: State) -> AnyPublisher<Action, Never> in
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }
            return self.fetch()
                .map(Action.onLoaded)
                .catch { error in
                    Just(Action.onFailedLoaded(error))
                }
                .eraseToAnyPublisher()
        }
    }
    
    func fetch() -> AnyPublisher<T, Error>{
        return Empty().eraseToAnyPublisher()
    }
}

extension LoadableViewModel {
    enum State {
        case start
        case loading
        case loaded(T)
        case failedLoaded(Error)
    }
    
    enum Action {
        case onAppear
        case onLoaded(T)
        case onFailedLoaded(Error)
    }
    
    func reduce(_ state: State, _ action: Action) -> State {
        switch state {
        case .start:
            switch action {
            case .onAppear:
                return .loading
            default:
                return state
            }
        case .loading:
            switch action {
            case .onFailedLoaded(let error):
                return .failedLoaded(error)
            case .onLoaded(let movies):
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
    
    
    
    func userInput(input: AnyPublisher<Action, Never>) -> Feedback<State, Action> {
        Feedback { _ in input }
    }
}

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
