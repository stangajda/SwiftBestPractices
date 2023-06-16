//
//  MockableMovieListServiceProtocol.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 27/04/2023.
//

import Foundation
import Combine
import Nimble

protocol MockableMovieListServiceProtocol: MockableBaseServiceProtocol {
    var mockManager: MovieListServiceProtocol { get }
}

extension MockableMovieListServiceProtocol {

    func fetchMovies(done: @escaping() -> Void, closure: @escaping (Result<Movies, Swift.Error>) -> Void) -> AnyCancellable? {
        var cancellable: AnyCancellable?
        cancellable = mockManager.fetchMovies(mockRequestUrl)
            .sinkToResult({ result in
                closure(result)
                done()
            })
        return cancellable

    }
}

protocol MockableMovieListViewModelProtocol: MockableBaseServiceProtocol {
    var viewModel: (any MoviesListViewModelProtocol)? { get }
}

extension MockableMovieListViewModelProtocol {

    func getMoviesFromLoadedState(done: @escaping() -> Void, closure: @escaping (Array<MoviesListViewModel.MovieItem>) -> Void) -> AnyCancellable? {
        var cancellable: AnyCancellable?
        cancellable = viewModel?.statePublisher.sink { state in
            switch state {
            case .loaded(let movies):
                closure(movies)
                done()
            default:
                break
            }
        }
        return cancellable
    }
    
    func getErrorFromFailedLoadedState(done: @escaping() -> Void, closure: @escaping (APIError) -> Void) -> AnyCancellable? {
        var cancellable: AnyCancellable?
        cancellable = viewModel?.statePublisher.sink { state in
            switch state {
            case .failedLoaded(let error):
                closure(APIError(error))
                done()
            default:
                break
            }
        }
        return cancellable
    }
}

protocol MockableMovieDetailViewModelProtocol: MockableBaseServiceProtocol {
    var viewModel: (any MovieDetailViewModelProtocol)? { get }
}

extension MockableMovieDetailViewModelProtocol {

    func getMovieFromLoadedState(done: @escaping() -> Void, closure: @escaping (MovieDetailViewModel.MovieDetailItem) -> Void) -> AnyCancellable? {
        var cancellable: AnyCancellable?
        cancellable = viewModel?.statePublisher.sink { state in
            switch state {
            case .loaded(let movie):
                closure(movie)
                done()
            default:
                break
            }
        }
        return cancellable
    }
    
    func getErrorFromFailedLoadedState(done: @escaping() -> Void, closure: @escaping (APIError) -> Void) -> AnyCancellable? {
        var cancellable: AnyCancellable?
        cancellable = viewModel?.statePublisher.sink { state in
            switch state {
            case .failedLoaded(let error):
                closure(APIError(error))
                done()
            default:
                break
            }
        }
        return cancellable
    }
}
