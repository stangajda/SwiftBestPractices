//
//  FDRMovieListServiceSpec.swift
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

class FDRMovieListServiceSpec: QuickSpec{
    typealias Mock = FDRMockURLProtocol.MockedResponse
    
    override func spec() {
        describe("check movie list service"){
            var cancellable: AnyCancellable?
            Resolver.registerMockServices()
            let mockMovieListManager: FDRMovieListService = FDRMovieListService()
            let mockRequestUrl: URLRequest = FDRMockAPIRequest["stubPath"]
            
            var dataFromFile: Data!
            context("given successful json data") {
                beforeEach {
                    dataFromFile = Data.load("FDRMockResponseResult.json")
                }
                
                it("it should get successful response match mapped object"){
                    let moviesFromData: FDRMovies = try JSONDecoder().decode(FDRMovies.self,
                                                                    from: dataFromFile)
                    FDRMockURLProtocol.mock = try Mock(request: mockRequestUrl, result: .success(moviesFromData))
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
                FDRMockURLProtocol.mock = nil
                cancellable?.cancel()
                cancellable = nil
            }
        }
    }
}
