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
    var mockManager: MovieListServiceProtocol{ get }
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
