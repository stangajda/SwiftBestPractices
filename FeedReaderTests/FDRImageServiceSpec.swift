//
//  FDRImageServiceSpec.swift
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

class FDRImageServiceSpec: QuickSpec{
    typealias Mock = FDRMockURLProtocol.MockedResponse
    override func spec() {
        describe("check image service"){
            var cancellable: AnyCancellable?
            Resolver.registerMockServices()
            let mockImageManager: FDRImageService = FDRImageService()
            let mockRequestUrl: URLRequest = URLRequest(url:FDRMockAPIRequest[FDRTrendingPath()]!).get()
            
            var uiImage: UIImage!
            context("given succesful image") {
                beforeEach {
                    uiImage = UIImage(named: "StubImage")
                }
                
                it("it should get succesful response on Type UIImage") {
                    guard let imageData = uiImage?.pngData() else {
                        throw FDRAPIError.imageConversion(mockRequestUrl)
                    }
            
                    FDRMockURLProtocol.mock = try Mock(request: mockRequestUrl, result: .success(imageData))
                    waitUntil{ done in
                        cancellable = mockImageManager.fetchImage(mockRequestUrl)
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
                    FDRMockURLProtocol.mock = try Mock(request: mockRequestUrl, result: .success(stubData))
                    waitUntil { done in
                        cancellable = mockImageManager.fetchImage(mockRequestUrl)
                            .sinkToResult({ result in
                                result.isExpectFailedToEqual(FDRAPIError.imageConversion(mockRequestUrl).errorDescription)
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
