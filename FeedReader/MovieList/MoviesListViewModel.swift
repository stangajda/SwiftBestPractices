//
//  MoviesListViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//

import Combine

class MoviesListViewModel: ObservableObject{
    @Published var movies: Movies?
    
    let service = Service()
    var cancellable: AnyCancellable?
    let request = APIRequest["Top250Movies"].get()
    
    init(){
    }
    
    func loadMovies(){
        cancellable = service.fetchMovies(request)
            .sinkToResult({ result in
            switch result{
                case .success(let data):
                    self.movies = data
                    break
                case .failure(let error):
                    Helper.printFailure(error)
                    break
                }
            })
    }
}
