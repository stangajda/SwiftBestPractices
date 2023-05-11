//
//  MockMoviesListViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 23/07/2021.
//

import Foundation
import Combine

class MockMoviesListViewModelLoaded: MoviesListViewModelProtocol {
    @Published var state: MoviesListViewModel.State = .loading()
    var input = PassthroughSubject<MoviesListViewModel.Action, Never>()
    var reset: () -> Void = {}
    var fetch: AnyPublisher<Array<MovieItem>, Error> {
        let movies = Array(repeating: MovieItem.mock, count: 20)
        return Just(movies)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
        
    }
}

class MockMoviesListViewModelLoading: MoviesListViewModelProtocol {
    @Published var state: MoviesListViewModel.State = .loading()
    var input = PassthroughSubject<MoviesListViewModel.Action, Never>()
    var reset: () -> Void = {}
    var fetch: AnyPublisher<Array<MovieItem>, Error> {
        return Empty(completeImmediately: false)
            .eraseToAnyPublisher()
    }
}

class MockMoviesListViewModelFailed: MoviesListViewModelProtocol {
    @Published var state: MoviesListViewModel.State = .loading()
    var input = PassthroughSubject<MoviesListViewModel.Action, Never>()
    var reset: () -> Void = {}
    var fetch: AnyPublisher<Array<MovieItem>, Error> {
        return Fail(error: APIError.apiCode(404))
            .eraseToAnyPublisher()
    }
}
