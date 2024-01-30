//
//  MovieDetailServiceSpec.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 07/06/2023.
//

import Foundation
@testable import FeedReader
import Combine
import Nimble
import Quick

class MovieDetailServiceSpec: QuickSpec {
    @Injected static var mockManager: MovieDetailServiceProtocol
    static var cancellable: AnyCancellable?
    static var mockRequestUrl: URLRequest = URLRequest(url: MockAPIRequest[StubEmptyPath()]).get()

    typealias Mock = MockURLProtocol.MockedResponse

    override class func spec() {
        describe("check movie detail service") {

            var moviesFromData: MovieDetail!
            var anotherMoviesFromData: MovieDetail!

            beforeEach {
                Injection.main.mockNetwork()
            }

            afterEach {
                MockURLProtocol.mock = nil
                cancellable?.cancel()
                cancellable = nil
            }

            context("when successful json data") {
                beforeEach {
                    moviesFromData = Data.jsonDataToObject(Config.MockMovieDetail.movieDetailResponseResult)
                    anotherMoviesFromData = Data.jsonDataToObject(
                        Config.MockMovieDetail.anotherMovieDetailResponseResult)
                    let result: Result<MovieDetail, Swift.Error> = .success(moviesFromData)
                    @Injected(result) var networkResponse: NetworkResponseProtocol
                }

                it("it should get successful response match mapped object") {
                    expect(self.fetchMovieDetailResult).to(beSuccessAndEqual(moviesFromData))
                }

                it("it should get successful response not match mapped object") {
                    expect(self.fetchMovieDetailResult).to(beSuccessAndNotEqual(anotherMoviesFromData))
                }
            }

            let errorCodes: [Int] = [300, 404, 500]
            errorCodes.forEach { errorCode in
                context("when failure error code \(errorCode)") {
                    beforeEach {
                        let result: Result<MovieDetail, Swift.Error> = .failure(APIError.apiCode(errorCode))
                        @Injected(result) var networkResponse: NetworkResponseProtocol
                    }

                    it("it should get failed response match error code") {
                        expect(self.fetchMovieDetailResult).to(beFailureAndMatchError(APIError.apiCode(errorCode)))
                    }
                }
            }

            context("when failure invalid url") {
                beforeEach {
                    let result: Result<MovieDetail, Swift.Error> = .failure(APIError.invalidURL)
                    @Injected(result) var networkResponse: NetworkResponseProtocol
                }

                it("it should get failed invalid url") {
                    expect(self.fetchMovieDetailResult).to(beFailureAndMatchError(APIError.invalidURL))
                }
            }

            context("when failure unknown response") {
                beforeEach {
                    let result: Result<MovieDetail, Swift.Error> = .failure(APIError.unknownResponse)
                    @Injected(result) var networkResponse: NetworkResponseProtocol
                }

                it("it should get failed unknown response") {
                    expect(self.fetchMovieDetailResult).to(beFailureAndMatchError(APIError.unknownResponse))
                }
            }

        }
    }

    class func fetchMovieDetailResult() -> Result<MovieDetail, Swift.Error> {
        var mainResult: Result<MovieDetail, Swift.Error>?
        waitUntil { done in
            cancellable = mockManager.fetchMovieDetail(mockRequestUrl)
                .sinkToResult({ result in
                    mainResult = result
                    done()
                })
        }

        guard let mainResult = mainResult else {
            fatalError("mainResult is nil")
        }

        return mainResult
    }
}
