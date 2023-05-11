//
//  MockmoviesDetailViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 24/07/2021.
//

import Foundation
import Combine

class MockMovieDetailViewModelLoaded: MovieDetailViewModelProtocol {
    var movieList: MovieItem
    var state: MovieDetailViewModel.State = .loaded(MovieDetailViewModel.MovieDetailItem(MovieDetail.mock))
    var input = PassthroughSubject<MovieDetailViewModel.Action, Never>()
    var fetch: AnyPublisher<MovieDetailViewModel.MovieDetailItem, Error>
    
    init(movieList: MovieItem){
        self.movieList = movieList
        self.fetch = Just(MovieDetailViewModel.MovieDetailItem(MovieDetail.mock))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

class MockMovieDetailViewModelLoading: MovieDetailViewModelProtocol {
    var movieList: MovieItem
    var state: MovieDetailViewModel.State = .loading()
    var input = PassthroughSubject<MovieDetailViewModel.Action, Never>()
    var fetch: AnyPublisher<MovieDetailViewModel.MovieDetailItem, Error>
    
    init(movieList: MovieItem){
        self.movieList = movieList
        self.fetch = Empty(completeImmediately: false)
            .eraseToAnyPublisher()
    }
}

class MockMovieDetailViewModelFailed: MovieDetailViewModelProtocol {
    var movieList: MovieItem
    var state: MovieDetailViewModel.State = .loading()
    var input = PassthroughSubject<MovieDetailViewModel.Action, Never>()
    var fetch: AnyPublisher<MovieDetailViewModel.MovieDetailItem, Error>
    
    init(movieList: MovieItem){
        self.movieList = movieList
        self.fetch = Fail(error: APIError.apiCode(404))
            .eraseToAnyPublisher()
    }
}

