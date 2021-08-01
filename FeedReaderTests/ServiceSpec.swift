//
//  FeedReaderTests.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 16/06/2021.
//
import Foundation
import UIKit
@testable import FeedReader
import Combine
import Resolver
import Nimble
import Quick

class ServiceSpec: QuickSpec {
    typealias Mock = MockURLProtocol.MockedResponse
    
    override func spec() {
        describe("check service responses") {
            var cancellable: AnyCancellable?
            Resolver.registerMockServices()
            let mockManager: Service = Service()
            var responseData = Data.stubData
            
            var result: Result<Data, Swift.Error>!
            let mockRequestUrl: URLRequest = MockAPIRequest["stubPath"].get()
            
            context("given succesful data in service") {
                
                beforeEach {
                    responseData = Data.stubData
                    result = .success(responseData)
                }
                
                it("it should get succesful response match to data"){
                    MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: result)
                    waitUntil{ done in
                        cancellable = mockManager.fetchData(mockRequestUrl)
                            .sinkToResult({ result in
                                result.isExpectSuccessToEqual(Data.stubData)
                                done()
                        })
                    }
                }
                
            }
            
            var dataFromFile: Data!
            context("given succesful json data") {
                beforeEach {
                    dataFromFile = Data.load("MockResponseResult.json")
                }
                
                it("it should get succesfull response match mapped object"){
                    let moviesFromData: Movies = try JSONDecoder().decode(Movies.self,
                                                                    from: dataFromFile)
                    MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: .success(moviesFromData))
                            waitUntil{ done in
                                cancellable = mockManager.fetchMovies(mockRequestUrl)
                                    .sinkToResult({ result in
                                        result.isExpectSuccessToEqual(moviesFromData)
                                        done()
                                    })
                            }
                }
            }
            
            var uiImage: UIImage!
            context("given succesful image") {
                beforeEach {
                    uiImage = UIImage(named: "StubImage")
                }
                
                it("it should get succesful response on Type UIImage") {
                    guard let imageData = uiImage?.pngData() else {
                        throw APIError.imageConversion(mockRequestUrl)
                    }
            
                    MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: .success(imageData))
                    waitUntil{ done in
                        cancellable = mockManager.fetchImage(mockRequestUrl)
                            .sinkToResult({ result in
                                result.isExpectSuccessType(UIImage())
                                done()
                            })
                    }
                }
            }
            
            var stubData:Data!
            context("given failure not image stubdata"){
                beforeEach {
                    stubData = Data.stubData
                }
                
                it("it should get failure response match error"){
                    MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: .success(stubData))
                    waitUntil { done in
                        cancellable = mockManager.fetchImage(mockRequestUrl)
                            .sinkToResult({ result in
                                result.isExpectFailedToEqual(APIError.imageConversion(mockRequestUrl).errorDescription)
                                done()
                            })
                    }
                }
            }
            
            let errorCodes: Array<Int> = [300,404,500]
            errorCodes.forEach { errorCode in
                context("given failure error code \(errorCode)"){
                    
                    it("it should get failure response match given error code \(errorCode)"){
                        let result: Result<Data, Error> = .failure(NSError.stubCode(code: errorCode))
                        MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: result, apiCode: errorCode)
                        waitUntil { done in
                            cancellable = mockManager.fetchData(mockRequestUrl)
                                .sinkToResult({ result in
                                    result.isExpectFailedToContain(APIError.apiCode(errorCode).errorDescription)
                                    done()
                                })
                        }
                    }
                }
            }
            
            var stubErrorCode: Int!
            var stubResult: Result<Bool, Swift.Error>!
            context("given succes response with error code 0"){
                beforeEach {
                    stubErrorCode = 0
                    stubResult = .success(false)
                }
                
                it("it should failure response match error code"){
                    MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: stubResult, apiCode: stubErrorCode)
                    waitUntil { done in
                        cancellable = mockManager.fetchData(mockRequestUrl)
                            .sinkToResult({ result in
                                result.isExpectFailedToEqual(APIError.apiCode(0).errorDescription)
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
