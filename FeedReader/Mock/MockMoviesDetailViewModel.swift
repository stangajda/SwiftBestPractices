//
//  MockmoviesDetailViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 24/07/2021.
//

import Foundation
import Combine


//class MockMovieDetailViewModel: MovieDetailViewModel{
//    var internalState: State = .start()
//    enum MockState {
//        case loading
//        case loaded
//        case failedLoaded
//    }
//    
//    override var state: State{
//        return internalState
//    }
//    
//    init(_ state: MockState){
//        super.init(movieList: MockMoviesListViewModel.MovieItem.mock)
//        switchState(state)
//    }
//    
//    var mockItems: MovieDetailItem{
//        return MovieDetailItem(MovieDetail.mock)
//    }
//    
//    func switchState(_ state:MockState){
//        let error = NSError(domain: "AnyDomain", code: 404, userInfo: nil)
//        switch state {
//        case .loading:
//            internalState = .loading()
//        case .loaded:
//            internalState = .loaded(mockItems)
//        case .failedLoaded:
//            internalState = .failedLoaded(error)
//        }
//    }
//}

class MockMovieDetailViewModelLoaded: MovieDetailViewModelProtocol {
    var movieList: MoviesListViewModel.MovieItem
    var state: MovieDetailViewModel.State = .loaded(MovieDetailViewModel.MovieDetailItem(MovieDetail.mock))
    var input = PassthroughSubject<MovieDetailViewModel.Action, Never>()
    var fetch: AnyPublisher<MovieDetailViewModel.MovieDetailItem, Error>
    
    init(movieList: MoviesListViewModel.MovieItem){
        self.movieList = movieList
        self.fetch = Just(MovieDetailViewModel.MovieDetailItem(MovieDetail.mock))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

class MockMovieDetailViewModelLoading: MovieDetailViewModelProtocol {
    var movieList: MoviesListViewModel.MovieItem
    var state: MovieDetailViewModel.State = .loading()
    var input = PassthroughSubject<MovieDetailViewModel.Action, Never>()
    var fetch: AnyPublisher<MovieDetailViewModel.MovieDetailItem, Error>
    
    init(movieList: MoviesListViewModel.MovieItem){
        self.movieList = movieList
        self.fetch = Empty(completeImmediately: false)
            .eraseToAnyPublisher()
    }
}

class MockMovieDetailViewModelFailed: MovieDetailViewModelProtocol {
    var movieList: MoviesListViewModel.MovieItem
    var state: MovieDetailViewModel.State = .loading()
    var input = PassthroughSubject<MovieDetailViewModel.Action, Never>()
    var fetch: AnyPublisher<MovieDetailViewModel.MovieDetailItem, Error>
    
    init(movieList: MoviesListViewModel.MovieItem){
        self.movieList = movieList
        self.fetch = Fail(error: APIError.apiCode(404))
            .eraseToAnyPublisher()
    }
}

