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
    
    func onAppear() {
        state = .loading
        loadMovies()
    }
    
}

extension MoviesListViewModel{
    enum State {
        case idle
        case loading
        case loaded(Array<Movie>)
        case failedLoaded(Error)
    }
}

extension MoviesListViewModel{
    func loadMovies(){
        let request = APIRequest["Top250Movies"].get()
        cancellable = service.fetchMovies(request)
            .sinkToResult({ result in
            switch result{
                case .success(let data):
                    self.state = .loaded(data.items)
                    break
                case .failure(let error):
                    self.state = .failedLoaded(error)
                    Helper.printFailure(error)
                    break
                }
            })
    }
}
