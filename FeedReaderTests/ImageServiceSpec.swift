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
            
            afterEach { [self] in
                MockURLProtocol.mock = nil
                cancellable?.cancel()
                cancellable = nil
            }
            
            context("when succesful image") {
                beforeEach { [self] in
                    let imageData = convertImageToData("stubImage")
                    mockResponse(result: .success(imageData))
                }
                
                it("it should get succesful response on Type UIImage") { [self] in
                    cancellable = await self.checkResponse { result in
                        result.isExpectSuccessType(UIImage())
                    }
                }
            }
            
            context("when failure not image stubdata"){
                beforeEach { [self] in
                    let stubData = Data.stubData
                    mockResponse(result: .success(stubData))
                }
                
                it("it should get failure response match error") { [self] in
                    cancellable = await self.checkResponse{ [unowned self] result in
                        result.isExpectFailedToEqual(APIError.imageConversion(mockRequestUrl).errorDescription)
                    }
                }
            }
            
        }
    }
}
