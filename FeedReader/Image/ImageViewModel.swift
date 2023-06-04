//
//  ImageViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//
import Combine
import UIKit
import SwiftUI

protocol ImageViewModelProtocol: ObservableLoadableProtocol where T == ImageViewModel.ImageItem, U == String {
   
}

//MARK: - ImageViewModel
final class ImageViewModel: ImageViewModelProtocol{
    @Published var state: State
    @Injected var service: ImageServiceProtocol
    
    fileprivate(set) var statePublisher: Published<State>.Publisher
    
    typealias State = LoadableEnums<T,U>.State
    typealias T = ImageViewModel.ImageItem
    typealias U = String
    
    var input = PassthroughSubject<Action, Never>()
    fileprivate var cache: ImageCacheProtocol?
    fileprivate var imagePath: String
    fileprivate var imageSizePath: ImagePathProtocol
    
    fileprivate var cancelable: AnyCancellable?
    
    init(imagePath: String, imageSizePath: ImagePathProtocol, cache: ImageCacheProtocol? = nil){
        state = State.loading(imagePath)
        statePublisher = _state.projectedValue
        self.imageSizePath = imageSizePath
        self.cache = cache
        self.imagePath = imagePath
        self.setUp()
    }
    
    fileprivate func getURL() -> URL?{
        return APIUrlImageBuilder[self.imageSizePath, imagePath]
    }
    
    fileprivate func setUp(){
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
    
    fileprivate func load(){
        cancelable = self.publishersSystem(state)
                        .assignNoRetain(to: \.state, on: self)
    }
    
    deinit {
        reset()
    }
    
    fileprivate lazy var reset: () -> Void = { [weak self] in
        self?.input.send(.onReset)
        self?.cancelable?.cancel()
    }
}

//Mark: - Fetch Publishers
extension ImageViewModel {
    func fetch() -> AnyPublisher<ImageItem, Error>{
        guard let url = getURL() else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        return self.service.fetchImage(URLRequest(url: url))
            .map { [unowned self] item in
                self.cache?[url] = item
                return ImageItem(item)
            }
            .eraseToAnyPublisher()
    }
}

//MARK: - ImageItem
extension ImageViewModel{
    struct ImageItem{
        let image: Image
        init(_ uiImage: UIImage){
            image = Image(uiImage: uiImage)
        }
    }
}

//MARK: - ImageWrapper
class AnyImageViewModelProtocol: ImageViewModelProtocol{
    fileprivate(set) var statePublisher: Published<State>.Publisher
    
    typealias ViewModel = ImageViewModel
    
    typealias State = LoadableEnums<T,U>.State
    typealias T = ViewModel.ImageItem
    typealias U = String
    
    var viewModel: any ImageViewModelProtocol
    
    @Published var state: ViewModel.State
    var input: PassthroughSubject<ViewModel.Action, Never>
    
    fileprivate var cancellable: AnyCancellable?
    init<ViewModel: ImageViewModelProtocol>(_ viewModel: ViewModel){
        state = viewModel.state
        input = viewModel.input
        statePublisher = viewModel.statePublisher
        self.viewModel = viewModel
        cancellable = viewModel.statePublisher.sink { [weak self] newState in
                    self?.state = newState
                }
    }
    
    func fetch() -> AnyPublisher<ViewModel.ImageItem, Error> {
        return viewModel.fetch()
    }
    
}

