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
    let service = Service()
    private var storage = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()
    
    init() {
        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                self.whenLoading(),
                Self.userInput(input: input.eraseToAnyPublisher())
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &storage)
    }
    
    deinit {
        storage.removeAll()
    }
    
    func send(event: Event) {
        input.send(event)
    }
}

extension MoviesListViewModel{
    enum State {
        case start
        case loading
        case loaded(Array<MovieItem>)
        case failedLoaded(Error)
    }
    
    enum Event {
        case onAppear
        case onSelectMovie(Int)
        case onMoviesLoaded(Array<MovieItem>)
        case onFailedToLoadMovies(Error)
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
}

extension MoviesListViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
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
    
    func whenLoading() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }
            let request = APIRequest["trending/movie/day"].get()
            
            return self.service.fetchMovies(request)
                .map { item in
                    item.results.map(MovieItem.init)
                }
                .map(Event.onMoviesLoaded)
                .catch { Just(Event.onFailedToLoadMovies($0)) }
                .eraseToAnyPublisher()
        }
    }
    
    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}

//extension MoviesListViewModel{
//    func loadMovies(){
//        let request = APIRequest["trending/movie/day"].get()
//        cancellable = service.fetchMovies(request)
//            .map { item in
//                item.results.map(MovieItem.init)
//            }
//            .sinkToResult({ [unowned self] result in
//            switch result{
//                case .success(let data):
//                    self.state = .loaded(data)
//                    break
//                case .failure(let error):
//                    self.state = .failedLoaded(error)
//                    Helper.printFailure(error)
//                    break
//                }
//            })
//    }
//}
