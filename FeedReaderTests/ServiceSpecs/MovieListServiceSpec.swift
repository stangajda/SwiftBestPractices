//
//  MovieListServiceSpec.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 02/08/2021.
//

import Foundation
import UIKit
@testable import FeedReader
import Combine
import Nimble
import Quick

class MovieListServiceSpec: QuickSpec, MockableMovieListServiceProtocol {
    @LazyInjected static var mockManager: MovieListServiceProtocol
    
    static var mockRequestUrl: URLRequest = URLRequest(url: MockAPIRequest[MockEmptyPath()]!).get()
    static var cancellable: AnyCancellable? = nil
    
    typealias Mock = MockURLProtocol.MockedResponse
    
    override class func spec() {
        describe("check movie list service"){
            
            var moviesFromData: Movies!
            var anotherMoviesFromData: Movies!
            
            afterEach {
                MockURLProtocol.mock = nil
                cancellable?.cancel()
                cancellable = nil
            }

            context("when successful json data") {
                beforeEach {
                    moviesFromData = Data.jsonDataToObject(Config.Mock.MovieList.movieListResponseResult)
                    anotherMoviesFromData = Data.jsonDataToObject(Config.Mock.MovieList.anotherMovieListResponseResult)
                    mockResponse(result: .success(moviesFromData))
                }
                
                it("it should get successful response match mapped object"){
                    expect(self.fetchMoviesResult).to(beSuccessAndEqual(moviesFromData))
                }

                it("it should get successful response not match mapped object"){
                    expect(self.fetchMoviesResult).to(beSuccessAndNotEqual(anotherMoviesFromData))
                }
                
            }
            
            let errorCodes: Array<Int> = [300,404,500]
            errorCodes.forEach { errorCode in
                context("when failure error code \(errorCode)"){
                    beforeEach { [self] in
                        mockResponse(result: .failure(APIError.apiCode(errorCode)))
                    }

                    it("it should get failed response match error code"){
                        expect(self.fetchMoviesResult).to(beFailureAndMatchError(APIError.apiCode(errorCode)))
                    }
                }
            }
  
            context("when failure invalid url") {
                beforeEach {
                    mockResponse(result: .failure(APIError.invalidURL))
                }
                
                it("it should get failed invalid url"){
                    expect(self.fetchMoviesResult).to(beFailureAndMatchError(APIError.invalidURL))
                }
            }
            
            context("when failure unknown response") {
                beforeEach {
                    mockResponse(result: .failure(APIError.unknownResponse))
                }
                
                it("it should get failed unknown response"){
                    expect(self.fetchMoviesResult).to(beFailureAndMatchError(APIError.unknownResponse))
                }
            }
            
        }
    }
    
    class func fetchMoviesResult() -> Result<Movies, Swift.Error> {
        var mainResult: Result<Movies, Swift.Error>? = nil
        waitUntil{ done in
            cancellable = mockManager.fetchMovies(mockRequestUrl)
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
