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
import Resolver
import Nimble
import Quick

class ImageServiceSpec: QuickSpec, MockableImageServiceProtocol{
    @LazyInjected var mockManager: ImageServiceProtocol
    lazy var mockRequestUrl: URLRequest = URLRequest(url:MockAPIRequest[TrendingPath()]!).get()
    lazy var cancellable: AnyCancellable? = nil
    
    override func spec() {
        describe("check image service"){
            Resolver.registerMockServices()
            context("given succesful image") {
                beforeEach { [self] in
                    let imageData = convertImageToData("stubImage")
                    mockResponse(result: .success(imageData))
                }
                
                it("it should get succesful response on Type UIImage") { [self] in
                    cancellable = await self.checkResponse( closure: { result in
                        result.isExpectSuccessType(UIImage())
                    })
                }
            }
            
            var stubData:Data!
            context("given failure not image stubdata"){
                beforeEach { [self] in
                    stubData = Data.stubData
                    mockResponse(result: .success(stubData))
                }
                
                it("it should get failure response match error") { [self] in
                    cancellable = await self.checkResponse( closure: { [self] result in
                        result.isExpectFailedToEqual(APIError.imageConversion(mockRequestUrl).errorDescription)
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
