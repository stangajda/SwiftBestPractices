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
    @LazyInjected var mockManager: MovieListServiceProtocol
    lazy var cancellable: AnyCancellable? = nil
    lazy var mockRequestUrl: URLRequest = URLRequest(url: MockAPIRequest[MockEmptyPath()]!).get()
    
    typealias Mock = MockURLProtocol.MockedResponse
    
    override func spec() {
        describe("check movie list service"){

            var moviesFromData: Movies!
            var anotherMoviesFromData: Movies!
            
            afterEach { [unowned self] in
                MockURLProtocol.mock = nil
                cancellable?.cancel()
                cancellable = nil
            }

            context("when successful json data") {
                beforeEach { [self] in
                    moviesFromData = Data.jsonDataToObject("MockMovieListResponseResult.json")
                    anotherMoviesFromData = Data.jsonDataToObject("MockAnotherMovieListResponseResult.json")
                    mockResponse(result: .success(moviesFromData))
                }
                
                it("it should get successful response match mapped object"){ [unowned self] in
                    expect(self.fetchMoviesResult).to(beSuccessAndEqual(moviesFromData))
                }

                it("it should get successful response not match mapped object"){ [unowned self] in
                    expect(self.fetchMoviesResult).to(beSuccessAndNotEqual(anotherMoviesFromData))
                }
                
            }
            
            let errorCodes: Array<Int> = [300,404,500]
            errorCodes.forEach { errorCode in
                context("when failure error code \(errorCode)"){
                    beforeEach { [self] in
                        mockResponse(result: .failure(APIError.apiCode(errorCode)))
                    }

                    it("it should get failed response match error code"){ [unowned self] in
                        expect(self.fetchMoviesResult).to(beFailureAndMatchError(APIError.apiCode(errorCode)))
                    }
                }
            }
  
            context("when failure invalid url") {
                beforeEach { [self] in
                    mockResponse(result: .failure(APIError.invalidURL))
                }
                
                it("it should get failed invalid url"){ [unowned self] in
                    expect(self.fetchMoviesResult).to(beFailureAndMatchError(APIError.invalidURL))
                }
            }
            
            context("when failure unknown response") {
                beforeEach { [self] in
                    mockResponse(result: .failure(APIError.unknownResponse))
                }
                
                it("it should get failed unknown response"){ [unowned self] in
                    expect(self.fetchMoviesResult).to(beFailureAndMatchError(APIError.unknownResponse))
                }
            }
            
        }
    }
    
    func fetchMoviesResult() -> Result<Movies, Swift.Error> {
        var mainResult: Result<Movies, Swift.Error>? = nil
        waitUntil{ [self] done in
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
