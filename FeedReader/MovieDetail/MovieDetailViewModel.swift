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

protocol Loadable {
    associatedtype T
    var input: PassthroughSubject<Action, Never> { get }
    var fetch: AnyPublisher<T, Error> { get }
}

extension Loadable {
    typealias State = LoadableEnums<T>.State
    typealias Action = LoadableEnums<T>.Action
    
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
    
    private func onStateChanged() -> Feedback<State, Action> {
        Feedback { (state: State) -> AnyPublisher<Action, Never> in
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }
            return self.fetch
                .map(Action.onLoaded)
                .catch { error in
                    Just(Action.onFailedLoaded(error))
                }
                .eraseToAnyPublisher()
        }
    }
    
    private func reduce(_ state: State, _ action: Action) -> State {
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
    
    private func userInput(input: AnyPublisher<Action, Never>) -> Feedback<State, Action> {
        Feedback { _ in input }
    }
}

struct LoadableEnums<T>{
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
}
