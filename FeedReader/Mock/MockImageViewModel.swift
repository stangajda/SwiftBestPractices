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
    typealias T = ImageViewModel.ImageItem
    typealias U = String
    
    @Published var state: ImageViewModel.State = .loading()
    var input = PassthroughSubject<ImageViewModel.Action, Never>()
    var image: UIImage?
    
    init(imageName: String) {
        image = UIImage(named: imageName)
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
}

final class MockImageViewModel: BaseMockImageViewModel {
    init(imagePath: String, imageSizePath: ImagePathProtocol, cache: ImageCacheProtocol? = nil) {
        super.init(imageName: "stubImageMovieMedium")
    }
}

final class MockImageViewModelDetail: BaseMockImageViewModel {
    init(imagePath: String, imageSizePath: ImagePathProtocol, cache: ImageCacheProtocol? = nil) {
        super.init(imageName: "stubImageMovieDetailsBig")
    }
}
