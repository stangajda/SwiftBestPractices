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

    func mockResponse<T:Encodable> (result: Result<T, Swift.Error>, apiCode: APICode = 200) {
        do {
            MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: result, apiCode: apiCode)
        } catch {
            fatalError("Error: \(error.localizedDescription)")
        }
    }

    func checkResponse(done: @escaping() -> Void, closure: @escaping (Result<Movies, Swift.Error>) -> Void) -> AnyCancellable? {
        var cancellable: AnyCancellable?
        cancellable = mockManager.fetchMovies(mockRequestUrl)
            .sinkToResult({ result in
                closure(result)
                done()
            })
        return cancellable
     
    }

}
