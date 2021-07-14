//
//  MovieDetailViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//

import Combine

class MovieDetailViewModel: ObservableObject{
    @Published private(set) var state = State.idle
    
    let service = Service()
    var cancellable: AnyCancellable?
    
    init(){
    }
    
    func onAppear(id: String){
        state = .loading(id)
        loadMovies(id: id)
    }
}

extension MovieDetailViewModel{
    enum State {
        case idle
        case loading(String)
        case loaded(MovieDetail)
        case failedLoaded(Error)
    }
}

extension MovieDetailViewModel{
    func loadMovies(id: String){
        
        let request = APIRequest["Title", id, "Images"]
        cancellable = service.fetchMovieDetail(request)
            .sinkToResult({ result in
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
