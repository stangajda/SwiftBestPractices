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
    @Published private(set) var state = State.loading
    var input = PassthroughSubject<Action, Never>()
    private let baseURL = "https://image.tmdb.org/t/p/original"
    private var cache: FDRImageCache?
    var imageUrl: String
    let service = FDRImageService()
    typealias T = FDRImageViewModel.ImageItem
    private var cancellable: AnyCancellable?
    
    init(imageURL: String, cache: FDRImageCache? = nil){
        self.cache = cache
        self.imageUrl = imageURL
        load()
    }
    
    func load(){
        let url = URL(string: baseURL + self.imageUrl)!
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

extension FDRImageViewModel: FDRLoadable {
    var fetch: AnyPublisher<T, Error>{
        let url = URL(string: baseURL + self.imageUrl)!
        let request = URLRequest(url: url).get()
        return self.service.fetchImage(request)
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
