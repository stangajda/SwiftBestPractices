//
//  MovieDetailViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//

import Combine

class MovieDetailViewModel: ObservableObject{
    @Published var movieDetail: MovieDetail?
    
    let service = Service()
    var cancellable: AnyCancellable?
    
    init(){
    }
    
    func loadMovies(id: String){
        
        let request = APIRequest["Title", id, "Images"]
        cancellable = service.fetchMovieDetail(request)
            .sinkToResult({ result in
            switch result{
                case .success(let movieDetail):
                    self.movieDetail = movieDetail
                    break
                case .failure(let error):
                    Helper.printFailure(error)
                    break
                }
            })
    }
}
