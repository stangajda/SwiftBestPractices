//
//  MockableMovieListServiceProtocol.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 27/04/2023.
//

import Foundation
import Combine
import Nimble

protocol MockableMovieDetailServiceProtocol: MockableBaseServiceProtocol {
    var mockManager: MovieDetailServiceProtocol { get }
}

extension MockableMovieDetailServiceProtocol {

    func fetchMovieDetail(done: @escaping() -> Void, closure: @escaping (Result<MovieDetail, Swift.Error>) -> Void) -> AnyCancellable? {
        var cancellable: AnyCancellable?
        cancellable = mockManager.fetchMovieDetail(mockRequestUrl)
            .sinkToResult({ result in
                closure(result)
                done()
            })
        return cancellable

    }

}
