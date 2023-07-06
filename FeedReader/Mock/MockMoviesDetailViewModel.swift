//
//  MockmoviesDetailViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 24/07/2021.
//

import Foundation
import Combine

class MockMovieDetailViewModel: MovieDetailViewModelProtocol {
    var statePublisher: Published<State>.Publisher
    
    var movieList: MoviesListViewModel.MovieItem
    @Published var state: MovieDetailViewModel.State = .start()
    var input = PassthroughSubject<MovieDetailViewModel.Action, Never>()
    var mockState: MockState.State
    
    fileprivate var cancellable: AnyCancellable?
    
    init(_ mockState: MockState.State, _ movieList: MoviesListViewModel.MovieItem){
        self.mockState = mockState
        self.movieList = movieList
        self.statePublisher = _state.projectedValue
        onAppear()
    }
    
    init(_ movieList: MoviesListViewModel.MovieItem){
        self.mockState = .loaded
        self.movieList = movieList
        self.statePublisher = _state.projectedValue
        onAppear()
    }
    

    func fetch() -> AnyPublisher<MovieDetailViewModel.MovieDetailItem, Error> {
        switch mockState {
        case .loading:
            return Empty(completeImmediately: false)
                .eraseToAnyPublisher()
        case .loaded:
            state = .loaded(MovieDetailViewModel.MovieDetailItem.mock)
            return Just(MovieDetailViewModel.MovieDetailItem.mock)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        case .failedLoaded:
            return Fail(error: APIError.apiCode(404))
                .eraseToAnyPublisher()
        }
    }
    
    func onAppear() {
        cancellable = self.assignNoRetain(self, to: \.state)
        send(action: .onAppear)
    }
    
    func onDisappear() {
        send(action: .onReset)
        cancellable?.cancel()
    }
}
