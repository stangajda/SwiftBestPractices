//
//  MockMoviesListViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 23/07/2021.
//

import Foundation
import Combine

class MockMoviesListViewModel: MoviesListViewModelProtocol {
    @Published var state: MoviesListViewModel.State = .loading()
    var input = PassthroughSubject<MoviesListViewModel.Action, Never>()
    var reset: () -> Void = {}
    var fetch: AnyPublisher<Array<MoviesListViewModel.MovieItem>, Error> {
        let movies = Array(repeating: MoviesListViewModel.MovieItem.mock, count: 20)
        return Just(movies)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
        
    }
}

class MockMoviesListViewModelLoading: MoviesListViewModelProtocol {
    @Published var state: MoviesListViewModel.State = .loading()
    var input = PassthroughSubject<MoviesListViewModel.Action, Never>()
    var reset: () -> Void = {}
    var fetch: AnyPublisher<Array<MoviesListViewModel.MovieItem>, Error> {
        return Empty(completeImmediately: false)
            .eraseToAnyPublisher()
    }
}

class MockMoviesListViewModelError: MoviesListViewModelProtocol {
    @Published var state: MoviesListViewModel.State = .loading()
    var input = PassthroughSubject<MoviesListViewModel.Action, Never>()
    var reset: () -> Void = {}
    var fetch: AnyPublisher<Array<MoviesListViewModel.MovieItem>, Error> {
        return Fail(error: APIError.apiCode(404))
            .eraseToAnyPublisher()
    }
}
