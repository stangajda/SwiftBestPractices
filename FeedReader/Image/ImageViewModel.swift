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

protocol ImageViewModelProtocol: LoadableProtocol{
    var state: LoadableEnums<T,U>.State { get }
    var input: PassthroughSubject<Action, Never> { get }
    func cancel()
}

class ImageViewModel: ObservableObject, ImageViewModelProtocol{
    @Published private(set) var state: State
    @Injected var service: ImageServiceProtocol
    
    typealias State = LoadableEnums<T,U>.State
    typealias T = ImageViewModel.ImageItem
    typealias U = String
    
    var input = PassthroughSubject<Action, Never>()
    private var cache: ImageCacheProtocol?
    private var imagePath: String
    private var imageSizePath: ImagePathProtocol
    
    private var cancellable: AnyCancellable?
    
    init(imagePath: String, imageSizePath: ImagePathProtocol, cache: ImageCacheProtocol? = nil){
        state = State.loading(imagePath)
        self.imageSizePath = imageSizePath
        self.cache = cache
        self.imagePath = imagePath
        setUp()
    }
    
    private func getURL() -> URL?{
        return APIUrlImageBuilder[imageSizePath,imagePath]
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
        cancellable = self.publishersSystem(state)
                        .assignNoRetain(to: \.state, on: self)
    }
    
    deinit {
        cancel()
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
}

extension ImageViewModel: LoadableProtocol {
    var fetch: AnyPublisher<T, Error>{
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

extension ImageViewModel{
    struct ImageItem{
        let image: Image
        init(_ uiImage: UIImage) {
            image = Image(uiImage: uiImage)
        }
    }
}
