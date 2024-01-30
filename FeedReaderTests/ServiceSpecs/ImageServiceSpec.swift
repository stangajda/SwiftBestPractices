//
//  ImageServiceSpec.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 02/08/2021.
//

import UIKit
@testable import FeedReader
import Combine
import Nimble
import Quick

class ImageServiceSpec: QuickSpec {
    @Injected static var mockManager: ImageServiceProtocol

    static var mockRequestUrl: URLRequest = URLRequest(url: MockAPIRequest[StubEmptyPath()]).get()
    static var cancellable: AnyCancellable?

    typealias Mock = MockURLProtocol.MockedResponse

    override class func spec() {
        describe("check image service") {
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
                    let testImage = UIImage(named: Config.MockImage.stubImageMovieMedium)
                    let imageData = convertImageToData(testImage)
                    let result: Result<Data, Swift.Error> = .success(imageData)
                    @Injected(result) var networkResponse: NetworkResponseProtocol
                }

                it("it should get succesful response on Type UIImage") {
                    expect(self.fetchImageResult).to(beSuccess { value in
                        expect(value).to(beAnInstanceOf(UIImage.self))
                    })
                }
            }

            context("when failure not image stubdata") {
                beforeEach {
                    let stubData = Data.stubData
                    let result: Result<Data, Swift.Error> = .success(stubData)
                    @Injected(result) var networkResponse: NetworkResponseProtocol
                }

                it("it should get failure response match error") {
                    expect(self.fetchImageResult).to(beFailureAndMatchError(APIError.imageConversion(mockRequestUrl)))
                }
            }

            let errorCodes: [Int] = [300, 404, 500]
            errorCodes.forEach { errorCode in
                context("when failure error code \(errorCode)") {
                    beforeEach {
                        let result: Result<Data, Swift.Error> = .failure(APIError.apiCode(errorCode))
                        @Injected(result) var networkResponse: NetworkResponseProtocol
                    }

                    it("it should get failed response match error code") {
                        expect(self.fetchImageResult).to(beFailureAndMatchError(APIError.apiCode(errorCode)))
                    }
                }
            }

            context("when failure invalid url") {
                beforeEach {
                    let result: Result<Data, Swift.Error> = .failure(APIError.invalidURL)
                    @Injected(result) var networkResponse: NetworkResponseProtocol
                }

                it("it should get failed invalid url") {
                    expect(self.fetchImageResult).to(beFailureAndMatchError(APIError.invalidURL))
                }
            }

            context("when failure unknown response") {
                beforeEach {
                    let result: Result<Data, Swift.Error> = .failure(APIError.unknownResponse)
                    @Injected(result) var networkResponse: NetworkResponseProtocol
                }

                it("it should get failed unknown response") {
                    expect(self.fetchImageResult).to(beFailureAndMatchError(APIError.unknownResponse))
                }
            }

            context("when failure image conversion") {
                beforeEach {
                    let result: Result<Data, Swift.Error> = .failure(APIError.imageConversion(mockRequestUrl))
                    @Injected(result) var networkResponse: NetworkResponseProtocol
                }

                it("it should get failed image conversion") {
                    expect(self.fetchImageResult).to(beFailureAndMatchError(APIError.imageConversion(mockRequestUrl)))
                }
            }

        }
    }

    static func fetchImageResult() -> Result<UIImage, Swift.Error> {
        var mainResult: Result<UIImage, Swift.Error>?
        waitUntil { done in
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
