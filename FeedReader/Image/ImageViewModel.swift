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
    @Published fileprivate(set) var state = State.loading()
    @Injected var service: ImageServiceProtocol
    
    fileprivate(set) var statePublisher: Published<State>.Publisher
    
    typealias State = LoadableEnums<T,U>.State
    typealias T = ImageViewModel.ImageItem
    typealias U = String
    
    var input = PassthroughSubject<Action, Never>()
    fileprivate var cache: ImageCacheProtocol?
    fileprivate var imagePath: String
    fileprivate var imageSizePath: ImagePathProtocol
    
    fileprivate var cancellable: AnyCancellable?
    fileprivate static var fullPath: String = String()
    
    static var instances: [String: ImageViewModel] = [:]

    static func instance(imagePath: String, imageSizePath: ImagePathProtocol, cache: ImageCacheProtocol? = nil) -> ImageViewModel {
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
    
    fileprivate init(imagePath: String, imageSizePath: ImagePathProtocol, cache: ImageCacheProtocol? = nil){
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
        cancellable = self.assignNoRetain(self, to: \.state)
    }
    
    deinit {
        reset()
    }
    
    fileprivate func reset(){
        cancellable?.cancel()
        Self.deallocateCurrentInstance()
    }
    
    func onResetAction(){
        reset()
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
    struct ImageItem: Equatable{
        let image: Image
        init(_ uiImage: UIImage){
            image = Image(uiImage: uiImage)
        }
    }
}




