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
    var fetch: AnyPublisher<ImageViewModel.ImageItem, Error>
    
    init(imageName: String) {
        let image = UIImage(named: imageName)
        guard let image = image else {
            self.fetch = Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
            return
        }
        
        self.fetch = Just(ImageViewModel.ImageItem(image))
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
