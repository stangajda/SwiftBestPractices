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
            let mockRequestUrl: URLRequest = URLRequest(url:MockAPIRequest[TrendingPath()]!).get()
            
            context("given successful data in service") {
                
                beforeEach {
                    responseData = Data.stubData
                    result = .success(responseData)
                    do {
                        MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: result)
                    } catch {
                        fatalError("Error: \(error.localizedDescription)")
                    }
                }
                
                it("it should get successful response match to data"){
                    waitUntil{ done in
                        cancellable = mockManager.fetchData(mockRequestUrl)
                            .sinkToResult({ result in
                                result.isExpectSuccessToEqual(Data.stubData)
                                done()
                        })
                    }
                }
                
            }
            
            let errorCodes: Array<Int> = [300,404,500]
            errorCodes.forEach { errorCode in
                context("given failure error code \(errorCode)"){
                    let result: Result<Data, Error> = .failure(NSError.stubCode(code: errorCode))
                    beforeEach {
                        do {
                            MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: result, apiCode: errorCode)
                        } catch {
                            fatalError("Error: \(error.localizedDescription)")
                        }
                    }
                    
                    it("it should get failure response match given error code \(errorCode)"){
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
            context("given successful response with error code 0"){
                beforeEach {
                    stubErrorCode = 0
                    stubResult = .success(false)
                    do {
                        MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: stubResult, apiCode: stubErrorCode)
                    } catch {
                        fatalError("Error: \(error.localizedDescription)")
                    }
                }
                
                it("it should failure response match error code"){
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
