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
import Nimble
import Quick

class ServiceSpec: QuickSpec {
    @Injected static var mockManager: ServiceProtocol
    static var cancellable: AnyCancellable? = nil
    static var mockRequestUrl: URLRequest = URLRequest(url: MockAPIRequest[StubEmptyPath()]).get()
    
    override class func spec() {
        describe("check service responses") {
            
            beforeEach {
                Injection.main.mockNetwork()
            }
            
            afterEach { [self] in
                MockURLProtocol.mock = nil
                cancellable?.cancel()
                cancellable = nil
            }
            
            context("when successful data in service") {
                
                beforeEach {
                    let result: Result<Data, Swift.Error> = .success(Data.stubData)
                    @Injected(result) var networkResponse: NetworkResponseProtocol
                }
                
                it("it should get successful response match to data"){ [self] in
                    expect(self.fetchDataResult).to(beSuccessAndEqual(Data.stubData))
                }
                
            }
            
            let errorCodes: Array<Int> = [300,404,500]
            errorCodes.forEach { errorCode in
                context("when failure error code \(errorCode)"){
                    beforeEach {
                        let result: Result<Data, Swift.Error> = .failure(APIError.apiCode(errorCode))
                        @Injected(result) var networkResponse: NetworkResponseProtocol
                    }

                    it("it should get failure response match given error code \(errorCode)"){ [self] in
                        expect(self.fetchDataResult).to(beFailureAndMatchError(APIError.apiCode(errorCode)))
                    }

                    it("it should not get failure response match error code 0"){ [self] in
                        expect(self.fetchDataResult).to(beFailureAndNotMatchError(APIError.apiCode(0)))
                    }

                }
            }
            
            context("when successful response with error code 0"){
                beforeEach {
                    let result: Result<Data, Swift.Error> = .failure(APIError.apiCode(0))
                    @Injected(result) var networkResponse: NetworkResponseProtocol
                }

                it("it should failure response match error code"){ [self] in
                    expect(self.fetchDataResult).to(beFailureAndMatchError(APIError.apiCode(0)))
                }
            }
            
        }
    }
    
    static func fetchDataResult() -> Result<Data, Swift.Error> {
        var mainResult: Result<Data, Swift.Error> = .success(Data())
        waitUntil{ done in
            cancellable = mockManager.fetchData(mockRequestUrl)
                .sinkToResult({ result in
                    mainResult = result
                    done()
                })
        }
        return mainResult
    }
    
}
