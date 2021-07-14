//
//  MoviesListViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//

import Combine

class MoviesListViewModel: ObservableObject{
    @Published private(set) var state = State.idle
    let service = Service()
    var cancellable: AnyCancellable?
    
    init(){
    }
    
    func send(event: Event) {
        self.state = self.reduce(self.state, event)
    }
    
}

extension MoviesListViewModel{
    enum State {
        case idle
        case loading
        case loaded(Array<Movie>)
        case error(Error)
    }
    enum Event {
        case onAppear
        case onLoadedMovies(Array<Movie>)
        case onFailedMovies(Error)
    }
    
    func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .idle:
            switch event {
            case .onAppear:
                return .loading
            default:
                return state
            }
        case .loading:
            self.loadMovies()
            switch event {
            case .onFailedMovies(let error):
                return .error(error)
            case .onLoadedMovies(let movies):
                return .loaded(movies)
            default:
                return state
            }
        case .loaded:
            return state
        case .error:
            return state
        }
    }
    
}

extension MoviesListViewModel{
    func loadMovies(){
        let request = APIRequest["Top250Movies"].get()
        cancellable = service.fetchMovies(request)
            .sinkToResult({ result in
            switch result{
                case .success(let data):
                    self.state = self.reduce(self.state, .onLoadedMovies(data.items))
                    break
                case .failure(let error):
                    self.state = self.reduce(self.state, .onFailedMovies(error))
                    Helper.printFailure(error)
                    break
                }
            })
    }
}
