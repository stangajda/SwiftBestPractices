//
//  MockImageViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 23/07/2021.
//

import UIKit
import Combine

class BaseMockImageViewModel: ImageViewModelProtocol {
    var statePublisher: Published<State>.Publisher

    typealias GENERIC_RES_TYPE = ImageViewModel.ImageItem
    typealias GENERIC_REQ_TYPE = String

    @Published var state: ImageViewModel.State = .loading()
    var input = PassthroughSubject<ImageViewModel.Action, Never>()
    var image: UIImage

    fileprivate var cancellable: AnyCancellable?

    init(imageName: String) {
        image = UIImage(named: imageName) ?? UIImage()
        statePublisher = _state.projectedValue
        onAppear()
    }

    func onAppear() {
        cancellable = self.assignNoRetain(self, to: \.state)
        send(action: .onAppear)
    }

    func onDisappear() {
        send(action: .onReset)
        cancellable?.cancel()
    }

    func fetch() -> AnyPublisher<ImageViewModel.ImageItem, Error> {
        let imageItem = ImageViewModel.ImageItem(image)
        state = .loaded(imageItem)
        return Just(imageItem)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

final class MockImageViewModel: BaseMockImageViewModel {
    init(imagePath: String, imageSizePath: ImagePathProtocol, cache: ImageCacheProtocol? = nil) {
        super.init(imageName: Config.MockImage.stubImageMovieMedium)
    }
}

final class MockImageViewModelDetail: BaseMockImageViewModel {
    init(imagePath: String, imageSizePath: ImagePathProtocol, cache: ImageCacheProtocol? = nil) {
        super.init(imageName: Config.MockImage.stubImageMoviedetailsBig)
    }
}

final class MockFailedImageViewModel: BaseMockImageViewModel {
    init(imagePath: String, imageSizePath: ImagePathProtocol, cache: ImageCacheProtocol? = nil) {
        super.init(imageName: Config.MockImage.stubImageMovieMedium)
    }

    override func fetch() -> AnyPublisher<ImageViewModel.ImageItem, Error> {
        return Fail(error: APIError.apiCode(404))
            .eraseToAnyPublisher()
    }
}
