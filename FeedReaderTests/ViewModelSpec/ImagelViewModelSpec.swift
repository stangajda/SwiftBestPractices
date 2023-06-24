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
                viewModel = ImageViewModel.instance(imagePath: "stubPath", imageSizePath: MockEmptyImagePath())
            }
            
            afterEach { [unowned self] in
                viewModel?.send(action: .onReset)
                MockURLProtocol.mock = nil
                viewModel = nil
                MovieDetailViewModel.deallocateAllInstances()
            }

            context("when send on appear action") {
                beforeEach { [unowned self] in
                    let testImage: UIImage = UIImage(named: "stubImageMovieMedium")!
                    let imageData = convertImageToData("stubImageMovieMedium")
                   
                    mockResponse(result: .success(imageData))
                    imageItem = ImageViewModel.ImageItem(testImage)
                    viewModel?.send(action: .onAppear)
                }
                
                it("it should get movies from loaded state match mapped object"){ [unowned self] in
                    await expect(self.viewModel?.state).toEventually(beLoadedState{ image in
                        expect(image).to(beAnInstanceOf(ImageViewModel.ImageItem.self))
                    })
                }
            }
            
            context("when send on reset action") {
                beforeEach { [unowned self] in
                    viewModel?.send(action: .onAppear)
                    viewModel?.send(action: .onReset)
                }
                
                it("it should get start state"){ [unowned self] in
                    await expect(self.viewModel?.state).toEventually(equal(.loading()))
                }
            }
            
            let errorCodes: Array<Int> = [300,404,500]
            errorCodes.forEach { errorCode in
                context("when error response with error code \(errorCode)") {
                    beforeEach { [unowned self] in
                        mockResponse(result: .failure(APIError.apiCode(errorCode)))
                        viewModel?.send(action: .onAppear)
                    }
                    
                    it("it should get state failed loaded with error code \(errorCode)"){ [unowned self] in
                        await expect(self.viewModel?.state).toEventually(equal(.failedLoaded(APIError.apiCode(errorCode))))
                    }
                }
            }
            
            context("when error response unknown error") {
                beforeEach { [unowned self] in
                    mockResponse(result: .failure(APIError.unknownResponse))
                    viewModel?.send(action: .onAppear)
                }
                
                it("it should get state failed loaded with unknown error"){ [unowned self] in
                    await expect(self.viewModel?.state).toEventually(equal(.failedLoaded(APIError.unknownResponse)))
                }
            }
            
            context("when deaalocate MovieDetailViewModel instances") {
                beforeEach { [unowned self] in
                    mockResponse(result: .failure(APIError.unknownResponse))
                    viewModel?.send(action: .onAppear)
                    MovieDetailViewModel.deallocateAllInstances()
                }
                
                it("it should get MovieDetailViewModel instances count 0"){
                    expect(MovieDetailViewModel.instances.count).to(equal(0))
                }
            }
            
            context("when deaalocate MovieDetailViewModel instances") {
                beforeEach { [unowned self] in
                    mockResponse(result: .failure(APIError.unknownResponse))
                    viewModel?.send(action: .onAppear)
                    MovieDetailViewModel.deallocateAllInstances()
                }
                
                it("it should get MovieDetailViewModel instances count 0"){
                    expect(MovieDetailViewModel.instances.count).to(equal(0))
                }
            }
        }
    }
}
