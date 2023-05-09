//
//  ImageViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//
import Combine
import UIKit
import SwiftUI
import Resolver

protocol ImageViewModelProtocol: ObservableLoadableProtocol{
    var state: ImageViewModel.State { get set }
    var input: PassthroughSubject<ImageViewModel.Action, Never> { get }
    var fetch: AnyPublisher<ImageViewModel.ImageItem, Error> { get }
}

final class ImageViewModel: ImageViewModelProtocol{
    
    @Published var state: State
    @Injected var service: ImageServiceProtocol
    
    typealias State = LoadableEnums<T,U>.State
    typealias T = ImageViewModel.ImageItem
    typealias U = String
    
    var input = PassthroughSubject<Action, Never>()
    private var cache: ImageCacheProtocol?
    private var imagePath: String
    private var imageSizePath: ImagePathProtocol
    
    private var cancelable: AnyCancellable?
    
    init(imagePath: String, imageSizePath: ImagePathProtocol, cache: ImageCacheProtocol? = nil){
        state = State.loading(imagePath)
        self.imageSizePath = imageSizePath
        self.cache = cache
        self.imagePath = imagePath
        self.setUp()
    }
    
    private func getURL() -> URL?{
        return APIUrlImageBuilder[OriginalPath(), imagePath]
    }
    
    private func setUp(){
        guard let url = getURL() else {
            state = .failedLoaded(APIError.invalidURL)
            return
        }
        
        if let image = cache?[url] {
            state = .loaded(ImageItem(image))
            return
        }
        
        load()
    }
    
    private func load(){
        cancelable = self.publishersSystem(state)
                        .assignNoRetain(to: \.state, on: self)
    }
    
    deinit {
        reset()
    }
    
    lazy var reset: () -> Void = { [unowned self] in
        input.send(.onReset)
        cancelable?.cancel()
    }
    
    var fetch: AnyPublisher<ImageItem, Error>{
        guard let url = getURL() else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        return self.service.fetchImage(URLRequest(url: url))
            .map { [self] item in
                self.cache?[url] = item
                return ImageItem(item)
            }
            .eraseToAnyPublisher()
    }
    
}

extension ImageViewModel{
    struct ImageItem{
        let image: Image
        init(_ uiImage: UIImage){
            image = Image(uiImage: uiImage)
        }
    }
}

class ImageViewModelWrapper: ImageViewModelProtocol{
    typealias State = LoadableEnums<T,U>.State
    typealias T = ImageViewModel.ImageItem
    typealias U = String
    
    typealias ViewModel = ImageViewModel
    
    @Published var state: ImageViewModel.State
    var input: PassthroughSubject<ImageViewModel.Action, Never>
    var fetch: AnyPublisher<ImageViewModel.ImageItem, Error>
    
    private var cancellable: AnyCancellable?
    init<ViewModel: ImageViewModelProtocol>(_ viewModel: ViewModel){
        state = viewModel.state
        input = viewModel.input
        fetch = viewModel.fetch
        cancellable = self.assignNoRetain(self, to: \.state)
    }
    
}

