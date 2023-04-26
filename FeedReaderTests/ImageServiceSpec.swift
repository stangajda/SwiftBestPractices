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

class ImageServiceSpec: QuickSpec{
    typealias Mock = MockURLProtocol.MockedResponse
    override func spec() {
        describe("check image service"){
            var cancellable: AnyCancellable?
            Resolver.registerMockServices()
            let mockImageManager: ImageService = ImageService()
            let mockRequestUrl: URLRequest = URLRequest(url:MockAPIRequest[TrendingPath()]!).get()
            
            var uiImage: UIImage!
            context("given succesful image") {
                beforeEach {
                    do {
                        uiImage = UIImage(named: "stubImage")
                        guard let imageData = uiImage?.pngData() else {
                            throw APIError.imageConversion(mockRequestUrl)
                        }
                        MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: .success(imageData))
                    } catch {
                        fatalError("Error: \(error.localizedDescription)")
                    }
                }
                
                it("it should get succesful response on Type UIImage") {
                   
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
                
                it("it should get failure response match error") {
                    MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: .success(stubData))
                    waitUntil { done in
                        cancellable = mockImageManager.fetchImage(mockRequestUrl)
                            .sinkToResult({ result in
                                result.isExpectFailedToEqual(APIError.imageConversion(mockRequestUrl).errorDescription)
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
