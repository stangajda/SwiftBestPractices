//
//  FDRImageViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//
import Combine
import UIKit
import SwiftUI
import Resolver

class FDRImageViewModel: ObservableObject{
    @Published private(set) var state: FDRLoadableEnums<T,U>.State
    @Injected var service: FDRImageServiceInterface
    
    typealias T = FDRImageViewModel.ImageItem
    typealias U = String
    
    var input = PassthroughSubject<Action, Never>()
    private var cache: FDRImageCacheInterface?
    private var imagePath: String
    
    private var cancellable: AnyCancellable?
    
    init(imagePath: String, cache: FDRImageCacheInterface? = nil){
        state = State.loading(imagePath)
        self.cache = cache
        self.imagePath = imagePath
        setUp()
    }
    
    func getURL() -> URL?{
        return FDRAPIUrlBuilder.getImageURL(imagePath)
    }
    
    func setUp(){
        guard let url = getURL() else {
            state = .failedLoaded(FDRAPIError.invalidURL)
            return
        }
        
        if let image = cache?[url] {
            state = .loaded(ImageItem(image))
            return
        }
        
        load()
    }
    
    func load(){
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

extension FDRImageViewModel: FDRLoadableProtocol {
    var fetch: AnyPublisher<T, Error>{
        guard let url = getURL() else {
            return Fail(error: FDRAPIError.invalidURL)
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

extension FDRImageViewModel{
    struct ImageItem{
        let image: Image
        init(_ uiImage: UIImage) {
            image = Image(uiImage: uiImage)
        }
    }
}
