//
//  MovieDetailViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//
import Foundation
import Combine

final class MovieDetailViewModel: ObservableObject{
    
    typealias T = MovieDetailViewModel.MovieDetailItem
    var input = PassthroughSubject<LoadableViewModel2<MovieDetailItem>.Action, Never>()
    
    @Published private(set) var state: LoadableViewModel2<T>.State = LoadableViewModel2<T>.State.start
    var movieList: MoviesListViewModel.MovieItem
    
    let service = Service()
    private var cancellableStorage = Set<AnyCancellable>()
    
    init(movieList: MoviesListViewModel.MovieItem){
        self.movieList = movieList
        self.publishersSystem2(state)
        .assign(to: \.state, on: self)
        .store(in: &cancellableStorage)
    }
    
    deinit {
        cancellableStorage.removeAll()
    }
}

extension MovieDetailViewModel: Loadable2 {
    var fetch: AnyPublisher<MovieDetailItem, Error> {
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

protocol Loadable2 {
    associatedtype T
    var input: PassthroughSubject<LoadableViewModel2<T>.Action, Never> { get }
    var fetch: AnyPublisher<T, Error> { get }
}

extension Loadable2 {
    func publishersSystem2(_ state: LoadableViewModel2<T>.State) -> AnyPublisher<LoadableViewModel2<T>.State, Never> {
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
    
    func send(action: LoadableViewModel2<T>.Action) {
        input.send(action)
    }
    
    func onStateChanged() -> Feedback<LoadableViewModel2<T>.State, LoadableViewModel2<T>.Action> {
        Feedback { (state: LoadableViewModel2<T>.State) -> AnyPublisher<LoadableViewModel2<T>.Action, Never> in
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }
            return self.fetch
                .map(LoadableViewModel2<T>.Action.onLoaded)
                .catch { error in
                    Just(LoadableViewModel2<T>.Action.onFailedLoaded(error))
                }
                .eraseToAnyPublisher()
        }
    }
    
    func reduce(_ state: LoadableViewModel2<T>.State, _ action: LoadableViewModel2<T>.Action) -> LoadableViewModel2<T>.State {
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
    
    func userInput(input: AnyPublisher<LoadableViewModel2<T>.Action, Never>) -> Feedback<LoadableViewModel2<T>.State, LoadableViewModel2<T>.Action> {
        Feedback { _ in input }
    }
}



struct LoadableViewModel2<T>{
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
