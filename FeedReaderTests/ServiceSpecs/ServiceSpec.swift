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

class ServiceSpec: QuickSpec, MockableServiceProtocol {
    @LazyInjected var mockManager: ServiceProtocol
    lazy var cancellable: AnyCancellable? = nil
    lazy var mockRequestUrl: URLRequest = URLRequest(url: MockAPIRequest[MockEmptyPath()]!).get()
    var result: Result<Data, Swift.Error>!
    
    override func spec() {
        describe("check service responses") {
            
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
                    expect(self.fetchDataResult).to(beSuccessAndEqual(Data.stubData))
                }
                
            }
            
            let errorCodes: Array<Int> = [300,404,500]
            errorCodes.forEach { errorCode in
                context("when failure error code \(errorCode)"){
                    beforeEach { [self] in
                        result = .failure(APIError.apiCode(errorCode))
                        self.mockResponse(result: result, apiCode: errorCode)
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
                    let stubErrorCode = 0
                    let result: Result<Bool, Swift.Error>! = .success(false)
                    self.mockResponse(result: result, apiCode: stubErrorCode)
                }

                it("it should failure response match error code"){ [self] in
                    expect(self.fetchDataResult).to(beFailureAndMatchError(APIError.apiCode(0)))
                }
            }
            
        }
    }
    
    func fetchDataResult() -> Result<Data, Swift.Error> {
        var mainResult: Result<Data, Swift.Error> = .success(Data())
        waitUntil{ [self] done in
            cancellable = mockManager.fetchData(mockRequestUrl)
                .sinkToResult({ result in
                    mainResult = result
                    done()
                })
        }
        return mainResult
    }
    
}
