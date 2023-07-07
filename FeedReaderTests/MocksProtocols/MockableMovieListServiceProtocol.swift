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
    static var mockManager: MovieListServiceProtocol { get }
}

extension MockableMovieListServiceProtocol {
    static func fetchMovies(done: @escaping() -> Void, closure: @escaping (Result<Movies, Swift.Error>) -> Void) -> AnyCancellable? {
        var cancellable: AnyCancellable?
        cancellable = mockManager.fetchMovies(Self.mockRequestUrl)
            .sinkToResult({ result in
                closure(result)
                done()
            })
        return cancellable
    }
}

protocol MockableMovieListViewModelProtocol: MockableBaseServiceProtocol {
    static var viewModel: (any MoviesListViewModelProtocol)? { get }
}

protocol MockableMovieDetailViewModelProtocol: MockableBaseServiceProtocol {
    static var viewModel: (any MovieDetailViewModelProtocol)? { get }
}

protocol MockableImageViewModelProtocol: MockableBaseServiceProtocol {
    static var viewModel: (any ImageViewModelProtocol)? { get }
}
