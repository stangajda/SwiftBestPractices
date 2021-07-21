//
//  MovieDetailViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//
import Foundation
import Combine

final class MovieDetailViewModel: ObservableObject{
    @Published private(set) var state: LoadableEnums<T>.State = LoadableEnums<T>.State.start
    
    var input = PassthroughSubject<LoadableEnums<T>.Action, Never>()
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
    var input: PassthroughSubject<LoadableEnums<T>.Action, Never> { get }
    var fetch: AnyPublisher<T, Error> { get }
}

extension Loadable {
    func publishersSystem(_ state: LoadableEnums<T>.State) -> AnyPublisher<LoadableEnums<T>.State, Never> {
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
    
    func send(action: LoadableEnums<T>.Action) {
        input.send(action)
    }
    
    func onStateChanged() -> Feedback<LoadableEnums<T>.State, LoadableEnums<T>.Action> {
        Feedback { (state: LoadableEnums<T>.State) -> AnyPublisher<LoadableEnums<T>.Action, Never> in
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }
            return self.fetch
                .map(LoadableEnums<T>.Action.onLoaded)
                .catch { error in
                    Just(LoadableEnums<T>.Action.onFailedLoaded(error))
                }
                .eraseToAnyPublisher()
        }
    }
    
    func reduce(_ state: LoadableEnums<T>.State, _ action: LoadableEnums<T>.Action) -> LoadableEnums<T>.State {
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
    
    func userInput(input: AnyPublisher<LoadableEnums<T>.Action, Never>) -> Feedback<LoadableEnums<T>.State, LoadableEnums<T>.Action> {
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
