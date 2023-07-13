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
    @LazyInjected static var mockManager: ImageServiceProtocol
    
    static var mockRequestUrl: URLRequest = URLRequest(url:MockAPIRequest[MockEmptyPath()]!).get()
    static var cancellable: AnyCancellable? = nil
    
    typealias Mock = MockURLProtocol.MockedResponse
 
    override class func spec() {
        describe("check image service"){
            
            beforeEach {
                Injection.main.mockNetwork()
            }

            afterEach {
                MockURLProtocol.mock = nil
                cancellable?.cancel()
                cancellable = nil
            }
            
            context("when succesful image") {
                beforeEach {
                    let testImage = UIImage(named: Config.Mock.Image.stubImageMovieMedium)
                    let imageData = convertImageToData(testImage)
                    mockResponse(result: .success(imageData))
                }
                
                it("it should get succesful response on Type UIImage") {
                    expect(self.fetchImageResult).to(beSuccess{ value in
                        expect(value).to(beAnInstanceOf(UIImage.self))
                    })
                }
            }
            
            context("when failure not image stubdata"){
                beforeEach {
                    let stubData = Data.stubData
                    mockResponse(result: .success(stubData))
                }

                it("it should get failure response match error") {
                    expect(self.fetchImageResult).to(beFailureAndMatchError(APIError.imageConversion(mockRequestUrl)))
                }
            }
            
            let errorCodes: Array<Int> = [300,404,500]
            errorCodes.forEach { errorCode in
                context("when failure error code \(errorCode)"){
                    beforeEach {
                        mockResponse(result: .failure(APIError.apiCode(errorCode)))
                    }

                    it("it should get failed response match error code"){
                        expect(self.fetchImageResult).to(beFailureAndMatchError(APIError.apiCode(errorCode)))
                    }
                }
            }
  
            context("when failure invalid url") {
                beforeEach {
                    mockResponse(result: .failure(APIError.invalidURL))
                }
                
                it("it should get failed invalid url"){
                    expect(self.fetchImageResult).to(beFailureAndMatchError(APIError.invalidURL))
                }
            }
            
            context("when failure unknown response") {
                beforeEach {
                    mockResponse(result: .failure(APIError.unknownResponse))
                }
                
                it("it should get failed unknown response"){
                    expect(self.fetchImageResult).to(beFailureAndMatchError(APIError.unknownResponse))
                }
            }
            
            context("when failure image conversion") {
                beforeEach {
                    mockResponse(result: .failure(APIError.imageConversion(mockRequestUrl)))
                }
                
                it("it should get failed image conversion"){
                    expect(self.fetchImageResult).to(beFailureAndMatchError(APIError.imageConversion(mockRequestUrl)))
                }
            }
            
        }
    }
    
    static func fetchImageResult() -> Result<UIImage, Swift.Error> {
        var mainResult: Result<UIImage, Swift.Error>? = nil
        waitUntil{ done in
            cancellable = mockManager.fetchImage(mockRequestUrl)
                .sinkToResult({ result in
                    mainResult = result
                    done()
                })
        }
        
        guard let mainResult = mainResult else {
            fatalError("mainResult is nil")
        }
        
        return mainResult
    }
}
