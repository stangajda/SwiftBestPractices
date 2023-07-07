//
//  MovieDetailServiceSpec.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 07/06/2023.
//

import Foundation
import UIKit
@testable import FeedReader
import Combine
import Nimble
import Quick

class MovieDetailServiceSpec: QuickSpec, MockableMovieDetailServiceProtocol {
    @LazyInjected static var mockManager: MovieDetailServiceProtocol
    static var cancellable: AnyCancellable? = nil
    static var mockRequestUrl: URLRequest = URLRequest(url: MockAPIRequest[MockEmptyPath()]!).get()
    
    typealias Mock = MockURLProtocol.MockedResponse
    
    override class func spec() {
        describe("check movie detail service"){

            var moviesFromData: MovieDetail!
            var anotherMoviesFromData: MovieDetail!
            
            afterEach {
                MockURLProtocol.mock = nil
                cancellable?.cancel()
                cancellable = nil
            }

            context("when successful json data") {
                beforeEach {
                    moviesFromData = Data.jsonDataToObject(Config.Mock.MovieDetail.movieDetailResponseResult)
                    anotherMoviesFromData = Data.jsonDataToObject(Config.Mock.MovieDetail.anotherMovieDetailResponseResult)
                    mockResponse(result: .success(moviesFromData))
                }
                
                it("it should get successful response match mapped object"){
                    expect(self.fetchMovieDetailResult).to(beSuccessAndEqual(moviesFromData))
                }

                it("it should get successful response not match mapped object"){
                    expect(self.fetchMovieDetailResult).to(beSuccessAndNotEqual(anotherMoviesFromData))
                }
            }
            
            let errorCodes: Array<Int> = [300,404,500]
            errorCodes.forEach { errorCode in
                context("when failure error code \(errorCode)"){
                    beforeEach { [self] in
                        mockResponse(result: .failure(APIError.apiCode(errorCode)))
                    }

                    it("it should get failed response match error code"){
                        expect(self.fetchMovieDetailResult).to(beFailureAndMatchError(APIError.apiCode(errorCode)))
                    }
                }
            }
  
            context("when failure invalid url") {
                beforeEach { [self] in
                    mockResponse(result: .failure(APIError.invalidURL))
                }
                
                it("it should get failed invalid url"){
                    expect(self.fetchMovieDetailResult).to(beFailureAndMatchError(APIError.invalidURL))
                }
            }
            
            context("when failure unknown response") {
                beforeEach { [self] in
                    mockResponse(result: .failure(APIError.unknownResponse))
                }
                
                it("it should get failed unknown response"){
                    expect(self.fetchMovieDetailResult).to(beFailureAndMatchError(APIError.unknownResponse))
                }
            }
            
        }
    }
    
    class func fetchMovieDetailResult() -> Result<MovieDetail, Swift.Error> {
        var mainResult: Result<MovieDetail, Swift.Error>? = nil
        waitUntil{ done in
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
