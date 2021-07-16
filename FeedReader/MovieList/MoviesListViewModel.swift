//
//  MoviesListViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//

import Combine

class MoviesListViewModel: ObservableObject{
    @Published private(set) var state = State.initial
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
        case initial
        case loading
        case loaded(Array<MovieItem>)
        case failedLoaded(Error)
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

extension MoviesListViewModel{
    func loadMovies(){
        let request = APIRequest["trending/movie/day"].get()
        cancellable = service.fetchMovies(request)
            .map { item in
                item.results.map(MovieItem.init)
            }
            .sinkToResult({ [unowned self] result in
            switch result{
                case .success(let data):
                    self.state = .loaded(data)
                    break
                case .failure(let error):
                    self.state = .failedLoaded(error)
                    Helper.printFailure(error)
                    break
                }
            })
    }
}
