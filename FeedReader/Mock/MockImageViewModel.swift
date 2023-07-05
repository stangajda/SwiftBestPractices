//
//  MockImageViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 23/07/2021.
//

import Foundation
import UIKit
import Combine

class BaseMockImageViewModel: ImageViewModelProtocol {
    func setUp() {
        
    }
    
    var statePublisher: Published<State>.Publisher
    
    typealias T = ImageViewModel.ImageItem
    typealias U = String
    
    @Published var state: ImageViewModel.State = .loading()
    var input = PassthroughSubject<ImageViewModel.Action, Never>()
    var image: UIImage?
    
    fileprivate var cancellable: AnyCancellable?
    
    init(imageName: String) {
        image = UIImage(named: imageName)
        statePublisher = _state.projectedValue
        cancellable = self.assignNoRetain(self, to: \.state)
    }
    
    func fetch() -> AnyPublisher<ImageViewModel.ImageItem, Error> {
        guard let image = image else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        return Just(ImageViewModel.ImageItem(image))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func onResetAction() {
        
    }
}

final class MockImageViewModel: BaseMockImageViewModel {
    init(imagePath: String, imageSizePath: ImagePathProtocol, cache: ImageCacheProtocol? = nil) {
        super.init(imageName: Config.Mock.Image.stubImageMovieMedium)
    }
}

final class MockImageViewModelDetail: BaseMockImageViewModel {
    init(imagePath: String, imageSizePath: ImagePathProtocol, cache: ImageCacheProtocol? = nil) {
        super.init(imageName: Config.Mock.Image.stubImageMoviedetailsBig)
    }
}
