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

protocol MockableServiceProtocol {
    typealias Mock = MockURLProtocol.MockedResponse
    var mockManager: ServiceProtocol { get }
    var cancellable: AnyCancellable? { get set }
    var mockRequestUrl: URLRequest { get }
}

extension MockableServiceProtocol {
    func mockResponse(result: Result<Data, Swift.Error>, apiCode: APICode = 200) {
        do {
            MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: result, apiCode: apiCode)
        } catch {
            fatalError("Error: \(error.localizedDescription)")
        }
    }

    func mockResponse<T:Encodable> (result: Result<T, Swift.Error>, apiCode: APICode = 200) {
        do {
            MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: result, apiCode: apiCode)
        } catch {
            fatalError("Error: \(error.localizedDescription)")
        }
    }

    func checkResponse(closure: @escaping (Result<Data, Swift.Error>) -> Void) async -> AnyCancellable? {
        var cancellable: AnyCancellable?
        await waitUntil{ [self] done in
            cancellable = mockManager.fetchData(mockRequestUrl)
                .sinkToResult({ result in
                    closure(result)
                    done()
                })
        }
        return cancellable
    }

}

class ServiceSpec: QuickSpec, MockableServiceProtocol {
    @LazyInjected var mockManager: ServiceProtocol
    lazy var cancellable: AnyCancellable? = nil
    lazy var mockRequestUrl: URLRequest = URLRequest(url: MockAPIRequest[TrendingPath()]!).get()
    var result: Result<Data, Swift.Error>!
    
    override func spec() {
        describe("check service responses") {
            Resolver.registerMockServices()
            
            afterEach { [self] in
                MockURLProtocol.mock = nil
                cancellable?.cancel()
                cancellable = nil
            }
            
            context("when successful data in service") {
                
                beforeEach { [self] in
                    result = .success(Data.stubData)
                    mockResponse(result: result)
                }
                
                it("it should get successful response match to data"){ [self] in
                   cancellable = await checkResponse { result in
                       result.isExpectSuccessToEqual(Data.stubData)
                   }
                               
                }
                
            }
            
            let errorCodes: Array<Int> = [300,404,500]
            errorCodes.forEach { errorCode in
                context("when failure error code \(errorCode)"){
                    result = .failure(NSError.stubCode(code: errorCode))
                    beforeEach { [self] in
                        self.mockResponse(result: result, apiCode: errorCode)
                    }

                    it("it should get failure response match given error code \(errorCode)"){ [self] in
                        cancellable = await checkResponse { result in
                            result.isExpectFailedToContain(APIError.apiCode(errorCode).errorDescription)
                        }
                    }
                }
            }
            
            context("when successful response with error code 0"){
                beforeEach {
                    let stubErrorCode = 0
                    let result: Result<Bool, Swift.Error>! = .success(false)
                    self.mockResponse(result: result, apiCode: stubErrorCode)
                }

                it("it should failure response match error code"){ [self] in
                    cancellable = await checkResponse { result in
                        result.isExpectFailedToEqual(APIError.apiCode(0).errorDescription)
                    }
                }
            }
            
        }
    }
}
