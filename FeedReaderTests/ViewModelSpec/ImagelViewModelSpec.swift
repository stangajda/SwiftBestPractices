//
//  MovieListViewModelSpec.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 08/06/2023.
//

import Foundation
import UIKit
@testable import FeedReader
import Combine
import Nimble
import Quick
import SwiftUI

class ImageViewModelSpec: QuickSpec, MockableImageViewModelProtocol {
    lazy var mockRequestUrl: URLRequest = URLRequest(url: MockAPIRequest[MockEmptyPath()]!).get()
    lazy var viewModel: (any ImageViewModelProtocol)? = nil
    
    typealias Mock = MockURLProtocol.MockedResponse
    
    var imageItem: ImageViewModel.ImageItem!
    var anotherImageItem: ImageViewModel.ImageItem!
    
    override func spec() {
        describe("check movie list service"){

            beforeEach { [self] in
                viewModel = ImageViewModel.instance(imagePath: String(), imageSizePath: MockEmptyImagePath())
            }
            
            afterEach { [unowned self] in
                viewModel?.onDisappear()
                MockURLProtocol.mock = nil
                viewModel = nil
            }

            context("when send on appear action") {
                beforeEach { [unowned self] in
                    let testImage: UIImage = UIImage(named: Config.Mock.Image.stubImageMovieMedium)!
                    let imageData = convertImageToData(testImage)
                   
                    mockResponse(result: .success(imageData))
                    imageItem = ImageViewModel.ImageItem(testImage)
                    viewModel?.onAppear()
                }
                
                it("it should get movies from loaded state match mapped object"){ [unowned self] in
                    await expect(self.viewModel?.state).toEventually(beLoadedState{ image in
                        expect(image).to(beAnInstanceOf(ImageViewModel.ImageItem.self))
                    })
                }
            }
            
            context("when send on reset action") {
                beforeEach { [unowned self] in
                    viewModel?.onAppear()
                    viewModel?.onDisappear()
                }
                
                it("it should get loading state"){ [unowned self] in
                    await expect(self.viewModel?.state).toEventually(equal(.loading()))
                }
            }
            
            let errorCodes: Array<Int> = [300,404,500]
            errorCodes.forEach { errorCode in
                context("when error response with error code \(errorCode)") {
                    beforeEach { [unowned self] in
                        mockResponse(result: .failure(APIError.apiCode(errorCode)))
                        viewModel?.onAppear()
                    }
                    
                    it("it should get state failed loaded with error code \(errorCode)"){ [unowned self] in
                        await expect(self.viewModel?.state).toEventually(equal(.failedLoaded(APIError.apiCode(errorCode))))
                    }
                }
            }
            
            context("when error response unknown error") {
                beforeEach { [unowned self] in
                    mockResponse(result: .failure(APIError.unknownResponse))
                    viewModel?.onAppear()
                }
                
                it("it should get state failed loaded with unknown error"){ [unowned self] in
                    await expect(self.viewModel?.state).toEventually(equal(.failedLoaded(APIError.unknownResponse)))
                }
            }
            
            context("when 1 instance exist") {
                beforeEach { [unowned self] in
                    mockResponse(result: .failure(APIError.unknownResponse))
                    viewModel?.onAppear()
                }
                
                it("it should get MovieDetailViewModel instances count 1"){
                    expect(ImageViewModel.instances.count).to(equal(1))
                }
            }
            
            context("when deaalocate MovieDetailViewModel instances") {
                beforeEach { [unowned self] in
                    mockResponse(result: .failure(APIError.unknownResponse))
                    viewModel?.onAppear()
                    ImageViewModel.deallocateCurrentInstance()
                }
                
                it("it should get MovieDetailViewModel instances count 0"){
                    expect(ImageViewModel.instances.count).to(equal(0))
                }
            }
        }
    }
}
