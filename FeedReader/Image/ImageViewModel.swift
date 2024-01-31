//
//  ImageViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//
import Combine
import UIKit
import SwiftUI

protocol ImageViewModelProtocol: LifecycleProtocol, ObservableLoadableProtocol
    where GENERIC_REQ_TYPE == String, GENERIC_RES_TYPE == ImageViewModel.ImageItem {
}

// MARK: - ImageViewModel
final class ImageViewModel: ImageViewModelProtocol {
    @Published fileprivate(set) var state = State.loading()
    @Injected var service: ImageServiceProtocol

    fileprivate(set) var statePublisher: Published<State>.Publisher

    typealias State = LoadableEnums<GENERIC_REQ_TYPE, GENERIC_RES_TYPE>.State
    typealias GENERIC_REQ_TYPE = String
    typealias GENERIC_RES_TYPE = ImageViewModel.ImageItem

    var input = PassthroughSubject<Action, Never>()
    fileprivate var cache: ImageCacheProtocol?
    fileprivate var imagePath: String
    fileprivate var imageSizePath: ImagePathProtocol

    fileprivate var cancellable: AnyCancellable?
    fileprivate static var fullPath: String = String()

    static var instances: [String: ImageViewModel] = [:]

    static func instance(imagePath: String,
                         imageSizePath: ImagePathProtocol,
                         cache: ImageCacheProtocol? = nil) -> ImageViewModel {
        fullPath = imageSizePath.stringPath() + imagePath

        if let instance = instances[fullPath] {
            return instance
        } else {
            let instance = ImageViewModel(imagePath: imagePath, imageSizePath: imageSizePath, cache: cache)
            instances[fullPath] = instance
            return instance
        }
    }

    static func deallocateCurrentInstance() {
        instances.removeValue(forKey: fullPath)
    }

    fileprivate init(imagePath: String, imageSizePath: ImagePathProtocol, cache: ImageCacheProtocol? = nil) {
        statePublisher = _state.projectedValue
        self.imageSizePath = imageSizePath
        self.cache = cache
        self.imagePath = imagePath
        self.onAppear()
    }

    deinit {
        reset()
    }

    func onAppear() {
        cancellable = self.assignNoRetain(self, to: \.state)
        send(action: .onAppear)
    }

    func onDisappear() {
        reset()
    }

    fileprivate func reset() {
        send(action: .onReset)
        cancellable?.cancel()
        Self.deallocateCurrentInstance()
    }
}

// MARK: - Fetch Publishers
extension ImageViewModel {

    func fetch() -> AnyPublisher<ImageItem, Error> {
        let url = APIUrlImageBuilder[self.imageSizePath, imagePath]
        if let image = cache?[url] {
            let imageItem = ImageItem(image)
            state = .loaded(imageItem)
            return Just(imageItem)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        let urlRequest = URLRequest(url: url).get()
        return self.service.fetchImage(urlRequest)
            .map { [unowned self] item in
                self.cache?[url] = item
                return ImageItem(item)
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - ImageItem
extension ImageViewModel {
    struct ImageItem: Equatable {
        let image: Image
        init(_ uiImage: UIImage) {
            image = Image(uiImage: uiImage)
        }
    }
}
