//
//  ImageViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//
import Combine
import UIKit
import SwiftUI

class ImageViewModel: LoadableViewModel<ImageViewModel.ImageItem>, ObservableObject{
    @Published private(set) var state = State.start
    private let baseURL = "https://image.tmdb.org/t/p/original"
    var imageUrl: String
    
    let service = Service()
    private var cancellableStorage = Set<AnyCancellable>()
    
    init(imageURL: String){
        self.imageUrl = imageURL
        super.init()
        self.publishersSystem(state)
        .assign(to: \.state, on: self)
        .store(in: &cancellableStorage)
    }
    
    deinit {
        cancellableStorage.removeAll()
    }
    
    override func fetch() -> AnyPublisher<ImageViewModel.ImageItem, Error>{
        let request = URLRequest(url: URL(string: baseURL + self.imageUrl)!).get()
        return self.service.fetchImage(request)
            .map { item in
                ImageItem(item)
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
