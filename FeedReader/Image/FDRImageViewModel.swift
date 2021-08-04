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
    private var cache: FDRImageCache?
    var url: URL?
    
    private var cancellable: AnyCancellable?
    
    init(imagePath: String, cache: FDRImageCache? = nil){
        state = State.loading(imagePath)
        self.cache = cache
        url = FDRAPIUrl.getImageURL(imagePath)
        load()
    }
    
    func load(){
        guard let url = url else {
            return
        }
        
        if let image = cache?[url] {
            state = .loaded(ImageItem(image))
            return
        }
        
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
        guard let url = url else {
            return Fail(error: FDRAPIError.invalidURL)
                .eraseToAnyPublisher()
        }
        return self.service.fetchImage(URLRequest(url: url))
            .map { [unowned self] item in
                cache?[url] = item
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
