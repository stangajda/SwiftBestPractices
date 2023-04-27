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
import Resolver
import Nimble
import Quick

class MovieListServiceSpec: QuickSpec, MockableMovieListServiceProtocol {
    @LazyInjected var mockManager: MovieListServiceProtocol
    lazy var cancellable: AnyCancellable? = nil
    lazy var mockRequestUrl: URLRequest = URLRequest(url: MockAPIRequest[TrendingPath()]!).get()
    
    typealias Mock = MockURLProtocol.MockedResponse
    
    override func spec() {
        describe("check movie list service"){
            Resolver.registerMockServices()

            var moviesFromData: Movies!
            var anotherMoviesFromData: Movies!

            context("given successful json data") {
                beforeEach { [self] in
                    moviesFromData = Data.jsonDataToObject("MockMovieListResponseResult.json")
                    anotherMoviesFromData = Data.jsonDataToObject("MockAnotherMovieListResponseResult.json")
                    mockResponse(result: .success(moviesFromData) as Result<Movies, Swift.Error>)
                }
                
                it("it should get successful response match mapped object"){ [self] in
                    cancellable = await self.checkResponse( closure: { result in
                        result.isExpectSuccessToEqual(moviesFromData)
                    })
                }

                it("it should get successful response not match mapped object"){ [self] in
                    cancellable = await self.checkResponse( closure: { result in
                       result.isExpectSuccessNotToEqual(anotherMoviesFromData)
                    }) 
                }
                
            }
            
            afterEach { [self] in
                MockURLProtocol.mock = nil
                cancellable?.cancel()
                cancellable = nil
            }
        }
    }
}
