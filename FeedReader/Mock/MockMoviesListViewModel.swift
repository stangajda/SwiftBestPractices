//
//  MockMoviesListViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 23/07/2021.
//

import Foundation
import Combine

class MockMoviesListViewModel: MoviesListViewModelProtocol, MockStateProtocol {
    var statePublisher: Published<State>.Publisher
    
    @Published var state: MoviesListViewModel.State = .start()
    var input = PassthroughSubject<MoviesListViewModel.Action, Never>()
    var mockState: MockState.State
    
    fileprivate var cancellable: AnyCancellable?
    
    init(_ mockState: MockState.State){
        self.mockState = mockState
        statePublisher = _state.projectedValue
        cancellable = self.assignNoRetain(self, to: \.state)
    }

    func fetch() -> AnyPublisher<Array<MoviesListViewModel.MovieItem>, Error> {
        switch mockState {
        case .loading:
            return Empty(completeImmediately: false)
                .eraseToAnyPublisher()
        case .loaded:
            let moviesFromData: Movies = Data.jsonDataToObject(Config.Mock.MovieList.movieListResponseResult)
            let mappedMovies = moviesFromData.results.map(MoviesListViewModel.MovieItem.init)
            return Just(mappedMovies)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        case .failedLoaded:
            return Fail(error: APIError.apiCode(404))
                .eraseToAnyPublisher()
        }
    }
    
    func onResetAction() {
    }
}
