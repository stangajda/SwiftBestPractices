//
//  MockmoviesDetailViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 24/07/2021.
//

import Foundation
import Combine

class MockMovieDetailViewModel: MovieDetailViewModelProtocol {
    var movieList: MoviesListViewModel.MovieItem
    @Published var state: MovieDetailViewModel.State = .start()
    var input = PassthroughSubject<MovieDetailViewModel.Action, Never>()
    var mockState: MockState.State
    
    init(_ mockState: MockState.State, _ movieList: MoviesListViewModel.MovieItem){
        self.mockState = mockState
        self.movieList = movieList
    }
    
    init(_ movieList: MoviesListViewModel.MovieItem){
        self.mockState = .loaded
        self.movieList = movieList
    }
    

    var fetch: AnyPublisher<MovieDetailViewModel.MovieDetailItem, Error> {
        switch mockState {
        case .loading:
            return Empty(completeImmediately: false)
                .eraseToAnyPublisher()
        case .loaded:
            return Just(MovieDetailViewModel.MovieDetailItem(MovieDetail.mock))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        case .failedLoaded:
            return Fail(error: APIError.apiCode(404))
                .eraseToAnyPublisher()
        }
    }
}
