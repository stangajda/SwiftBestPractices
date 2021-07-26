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

class ImageViewModel: ObservableObject{
    @Published private(set) var state = State.start
    var input = PassthroughSubject<Action, Never>()
    private let baseURL = "https://image.tmdb.org/t/p/original"
    private var cache: ImageCache?
    var imageUrl: String
    let service = Service()
    private var cancellableStorage = Set<AnyCancellable>()
    typealias T = ImageViewModel.ImageItem
    
    init(imageURL: String, cache: ImageCache? = nil){
        self.cache = cache
        self.imageUrl = imageURL
        self.publishersSystem(state)
        .assignNoRetain(to: \.state, on: self)
        .store(in: &cancellableStorage)
    }
    
    deinit {
        cancellableStorage.removeAll()
    }
    
}

extension ImageViewModel: Loadable {
    var fetch: AnyPublisher<T, Error>{
        let url = URL(string: baseURL + self.imageUrl)!
        let request = URLRequest(url: url).get()
        
        if let image = cache?[url] {
            return Just(image)
                .map { item in
                    ImageItem(item)
                }
                .setFailureType(to: Error.self)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        
        return self.service.fetchImage(request)
            .map { [unowned self] item in
                cache?[url] = item
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
