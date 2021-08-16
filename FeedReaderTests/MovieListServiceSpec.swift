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
            var cancellable: AnyCancellable?
            Resolver.registerMockServices()
            let mockMovieListManager: MovieListService = MovieListService()
            let mockRequestUrl: URLRequest = URLRequest(url:MockAPIRequest[TrendingPath()]!).get()
            var dataFromFile: Data!
            context("given successful json data") {
                beforeEach {
                    dataFromFile = Data.load("MockMovieListResponseResult.json")
                }
                
                it("it should get successful response match mapped object"){
                    let moviesFromData: Movies = try JSONDecoder().decode(Movies.self,
                                                                    from: dataFromFile)
                    MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: .success(moviesFromData))
                            waitUntil{ done in
                                cancellable = mockMovieListManager.fetchMovies(mockRequestUrl)
                                    .sinkToResult({ result in
                                        result.isExpectSuccessToEqual(moviesFromData)
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
