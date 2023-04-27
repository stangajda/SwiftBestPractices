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

protocol MockableBaseService {
    typealias Mock = MockURLProtocol.MockedResponse
    var cancellable: AnyCancellable? { get }
    var mockRequestUrl: URLRequest { get }
}


protocol MockableMovieListService: MockableBaseService {
    var mockManager: MovieListServiceInterface { get }
}

extension MockableMovieListService {

    func mockResponse<T:Encodable> (result: Result<T, Swift.Error>, apiCode: APICode = 200) {
        do {
            MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: result, apiCode: apiCode)
        } catch {
            fatalError("Error: \(error.localizedDescription)")
        }
    }

    func checkResponse(closure: @escaping (Result<Movies, Swift.Error>) -> Void) async -> AnyCancellable? {
        var cancellable: AnyCancellable?
        await waitUntil{ [self] done in
            cancellable = mockManager.fetchMovies(mockRequestUrl)
                .sinkToResult({ result in
                    closure(result)
                    done()
                })
        }
        return cancellable
     }

}

class MovieListServiceSpec: QuickSpec, MockableMovieListService {
    @LazyInjected var mockManager: MovieListServiceInterface
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
