//
//  FDRMovieDetailViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//
import Foundation
import Combine
import Resolver

class FDRMovieDetailViewModel: ObservableObject{
    @Published private(set) var state: State
    @Injected var service: FDRMovieDetailServiceInterface
    
    typealias T = FDRMovieDetailViewModel.MovieDetailItem
    typealias U = Int
    
    var input = PassthroughSubject<Action, Never>()
    var movieList: FDRMoviesListViewModel.MovieItem
    
    private var cancellable: AnyCancellable?
    
    init(movieList: FDRMoviesListViewModel.MovieItem){
        state = State.start(movieList.id)
        self.movieList = movieList
        cancellable = self.publishersSystem(state)
            .assignNoRetain(to: \.state, on: self)
        
    }
    
    deinit {
        cancel()
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}

extension FDRMovieDetailViewModel: FDRLoadableProtocol {
    var fetch: AnyPublisher<T, Error> {
        let request = FDRAPIRequest.getRequest("movie/" + String(movieList.id))
        return self.service.fetchMovieDetail(request)
            .map { item in
                MovieDetailItem(item)
            }
            .eraseToAnyPublisher()
    }
}

extension FDRMovieDetailViewModel{
    struct MovieDetailItem {
        let id: Int
        let title: String
        let overview: String
        let backdrop_path: String
        
        init(_ movie: FDRMovieDetail) {
            id = movie.id
            title = movie.title
            overview = movie.overview
            backdrop_path = movie.backdrop_path
        }
    }
}
