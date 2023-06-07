//
//  ImageServiceSpec.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 02/08/2021.
//

import Foundation
import UIKit
@testable import FeedReader
import Combine
import Nimble
import Quick

class ImageServiceSpec: QuickSpec, MockableImageServiceProtocol{
    @LazyInjected var mockManager: ImageServiceProtocol
    
    lazy var mockRequestUrl: URLRequest = URLRequest(url:MockAPIRequest[MockEmptyPath()]!).get()
    lazy var cancellable: AnyCancellable? = nil
    
    typealias Mock = MockURLProtocol.MockedResponse
 
    override func spec() {
        describe("check image service"){

            afterEach { [unowned self] in
                MockURLProtocol.mock = nil
                cancellable?.cancel()
                cancellable = nil
            }
            
            context("when succesful image") {
                beforeEach { [self] in
                    let imageData = convertImageToData("stubImage")
                    mockResponse(result: .success(imageData))
                }
                
                it("it should get succesful response on Type UIImage") { [unowned self] in

                    await waitUntil{ [unowned self] done in
                        cancellable = self.fetchImage(done: done){ result in
                                result.isExpectSuccessType(UIImage())
                        }
                    }

                }
            }
            
            context("when failure not image stubdata"){
                beforeEach { [unowned self] in
                    let stubData = Data.stubData
                    mockResponse(result: .success(stubData))
                }

                it("it should get failure response match error") { [unowned self] in
                    await waitUntil{ [unowned self] done in
                        cancellable = self.fetchImage(done: done){ [unowned self] result in
                                result.isExpectFailedToMatchError(APIError.imageConversion(mockRequestUrl))
                        }
                    }
                }
            }
            
            let errorCodes: Array<Int> = [300,404,500]
            errorCodes.forEach { errorCode in
                context("when failure error code \(errorCode)"){
                    beforeEach { [self] in
                        mockResponse(result: .failure(APIError.apiCode(errorCode)))
                    }

                    it("it should get failed response match error code"){ [unowned self] in
                        await waitUntil{ [unowned self] done in
                            cancellable = self.fetchImage(done: done){ result in
                                result.isExpectFailedToMatchError(APIError.apiCode(errorCode))
                            }
                        }
                    }
                }
            }
  
            context("when failure invalid url") {
                beforeEach { [self] in
                    mockResponse(result: .failure(APIError.invalidURL))
                }
                
                it("it should get failed invalid url"){ [unowned self] in
                    await waitUntil{ [unowned self] done in
                        cancellable = self.fetchImage(done: done){ result in
                            result.isExpectFailedToMatchError(APIError.invalidURL)
                        }
                    }
                }
            }
            
            context("when failure invalid url") {
                beforeEach { [self] in
                    mockResponse(result: .failure(APIError.unknownResponse))
                }
                
                it("it should get failed invalid url"){ [unowned self] in
                    await waitUntil{ [unowned self] done in
                        cancellable = self.fetchImage(done: done){ result in
                            result.isExpectFailedToMatchError(APIError.unknownResponse)
                        }
                    }
                }
            }
            
            context("when failure image conversion") {
                beforeEach { [self] in
                    mockResponse(result: .failure(APIError.imageConversion(mockRequestUrl)))
                }
                
                it("it should get failed image conversion"){ [unowned self] in
                    await waitUntil{ [unowned self] done in
                        cancellable = self.fetchImage(done: done){ [self] result in
                            result.isExpectFailedToMatchError(APIError.imageConversion(mockRequestUrl))
                        }
                    }
                }
            }
            
        }
    }
}
