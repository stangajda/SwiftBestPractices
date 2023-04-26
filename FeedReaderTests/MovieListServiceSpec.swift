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

class MovieListServiceSpec: QuickSpec{
    typealias Mock = MockURLProtocol.MockedResponse
    
    override func spec() {
        describe("check movie list service"){
            Resolver.registerMockServices()

            let mockMovieListManager: MovieListService = MovieListService()
            let mockRequestUrl: URLRequest = URLRequest(url:MockAPIRequest[TrendingPath()]!).get()

            var cancellable: AnyCancellable?
            var dataFromFile: Data!
            var anotherDataFromFile: Data!
            var moviesFromData: Movies!
            var anotherMoviesFromData: Movies!

            context("given successful json data") {
                beforeEach {
                    // Arrange
                    // Given
                    dataFromFile = Data.load("MockMovieListResponseResult.json")
                    anotherDataFromFile = Data.load("MockAnotherMovieListResponseResult.json")
                    do {
                        moviesFromData = try JSONDecoder().decode(Movies.self, from: dataFromFile)
                        anotherMoviesFromData = try JSONDecoder().decode(Movies.self, from: anotherDataFromFile)
                        MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: .success(moviesFromData))
                    } catch {
                        fatalError("Error: \(error.localizedDescription)")
                    }

                }
                
                it("it should get successful response match mapped object"){
                    
                    waitUntil{ done in
                        cancellable = mockMovieListManager.fetchMovies(mockRequestUrl)
                            .sinkToResult({ result in
                                result.isExpectSuccessToEqual(moviesFromData)
                                done()
                            })
                    }
                    
                }

                it("it should get successful response not match mapped object"){
                   
                    waitUntil{ done in
                        cancellable = mockMovieListManager.fetchMovies(mockRequestUrl)
                            .sinkToResult({ result in
                                result.isExpectSuccessNotToEqual(anotherMoviesFromData)
                                done()
                            })
                    }
                    
                }
                
            }
            
            afterEach {
                MockURLProtocol.mock = nil
                cancellable?.cancel()
                cancellable = nil
            }
        }
    }
}
