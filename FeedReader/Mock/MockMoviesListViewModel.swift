//
//  MockMoviesListViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 23/07/2021.
//

import Foundation
import Combine

class MockMoviesListViewModel: MoviesListViewModelProtocol {
    @Published var state: MoviesListViewModel.State = .start()
    var input = PassthroughSubject<MoviesListViewModel.Action, Never>()
    var mockState: MockState
    enum MockState {
        case loading
        case loaded
        case failedLoaded
    }
    
    init(_ mockState: MockState){
        self.mockState = mockState
    }

    var fetch: AnyPublisher<Array<MoviesListViewModel.MovieItem>, Error> {
        switch mockState {
        case .loading:
            return Empty(completeImmediately: false)
                .eraseToAnyPublisher()
        case .loaded:
            return Just(Array(repeating: MoviesListViewModel.MovieItem.mock, count: 20))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        case .failedLoaded:
            return Fail(error: APIError.apiCode(404))
                .eraseToAnyPublisher()
        }
    }
}
