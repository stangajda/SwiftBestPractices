//
//  MovieListViewModelSpec.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 08/06/2023.
//

@testable import FeedReader
import Combine
import Nimble
import Quick
import SwiftUI

class ImageViewModelSpec: QuickSpec {
    override class func spec() {
        describe("check movie list service") {
            var viewModel: AnyImageViewModelProtocol?

            beforeEach {
                Injection.main.mockService()
                @Injected(String(), OriginalPath() as ImagePathProtocol)
                    var viewModelInjected: AnyImageViewModelProtocol
                viewModel = viewModelInjected
            }

            afterEach {
                viewModel?.onDisappear()
                MockURLProtocol.mock = nil
                viewModel = nil
                ImageViewModel.deallocateCurrentInstance()
            }

            context("when send on appear action") {
                beforeEach {
                    let testImage: UIImage = UIImage(named: Config.MockImage.stubImageMovieMedium)!
                    let result: Result<UIImage, Error> = .success(testImage)
                    @Injected(result) var service: ImageServiceProtocol
                    viewModel?.onAppear()
                }

                it("it should get movies from loaded state match mapped object") {
                    expect(viewModel?.state).toEventually(beLoadedState { image in
                        expect(image).to(beAnInstanceOf(ImageViewModel.ImageItem.self))
                    })
                }
            }

            context("when send on reset action") {
                beforeEach {
                    viewModel?.onAppear()
                    viewModel?.onDisappear()
                }

                it("it should get loading state") {
                    expect(viewModel?.state).toEventually(equal(.loading()))
                }
            }

            let errorCodes: [Int] = [300, 404, 500]
            errorCodes.forEach { errorCode in
                context("when error response with error code \(errorCode)") {
                    beforeEach {
                        let result: Result<UIImage, Error> = .failure(APIError.apiCode(errorCode))
                        @Injected(result) var service: ImageServiceProtocol
                        viewModel?.onAppear()
                    }

                    it("it should get state failed loaded with error code \(errorCode)") {
                        expect(viewModel?.state).toEventually(equal(.failedLoaded(APIError.apiCode(errorCode))))
                    }
                }
            }

            context("when error response unknown error") {
                beforeEach {
                    let result: Result<UIImage, Error> = .failure(APIError.unknownResponse)
                    @Injected(result) var service: ImageServiceProtocol
                    viewModel?.onAppear()
                }

                it("it should get state failed loaded with unknown error") {
                    expect(viewModel?.state).toEventually(equal(.failedLoaded(APIError.unknownResponse)))
                }
            }

            context("when 1 instance exist") {
                beforeEach {
                    let result: Result<UIImage, Error> = .failure(APIError.unknownResponse)
                    @Injected(result) var service: ImageServiceProtocol
                    viewModel?.onAppear()
                }

                it("it should get ImageViewModel instances count 1") {
                    expect(ImageViewModel.instances.count).to(equal(1))
                }
            }

            context("when allocate another instance") {
                beforeEach {
                    @Injected(String(), OriginalPath() as ImagePathProtocol)
                        var viewModelInjected: AnyImageViewModelProtocol
                    _ = ImageViewModel.instance(imagePath: String(), imageSizePath: OriginalPath() as ImagePathProtocol)
                }

                it("it should get ImageViewModel instances count 1") {
                    expect(ImageViewModel.instances.count).to(equal(1))
                }
            }

            context("when deaalocate ImageViewModel instances") {
                beforeEach {
                    let result: Result<UIImage, Error> = .failure(APIError.unknownResponse)
                    @Injected(result) var service: ImageServiceProtocol
                    viewModel?.onAppear()
                    ImageViewModel.deallocateCurrentInstance()
                }

                it("it should get ImageViewModel instances count 0") {
                    expect(ImageViewModel.instances.count).to(equal(0))
                }
            }
        }
    }
}
