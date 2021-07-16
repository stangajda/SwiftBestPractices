//
//  MovieDetailViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//

import Combine

class MovieDetailViewModel: ObservableObject{
    @Published private(set) var state = State.initial
    
    let service = Service()
    var cancellable: AnyCancellable?
    
    init(){
    }
    
    func onAppear(id: Int){
        state = .loading(id)
        loadMovies(id: id)
    }
}

extension MovieDetailViewModel{
    enum State {
        case initial
        case loading(Int)
        case loaded(MovieDetailItem)
        case failedLoaded(Error)
    }
    
    struct MovieDetailItem: Identifiable {
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

extension MovieDetailViewModel{
    func loadMovies(id: Int){
        let request = APIRequest["movie/" + String(id)]
        cancellable = service.fetchMovieDetail(request)
            .map { item in
                MovieDetailItem(item)
            }
            .sinkToResult({ [unowned self] result in
            switch result{
                case .success(let movieDetail):
                    self.state = .loaded(movieDetail)
                    break
                case .failure(let error):
                    self.state = .failedLoaded(error)
                    Helper.printFailure(error)
                    break
                }
            })
    }
}
