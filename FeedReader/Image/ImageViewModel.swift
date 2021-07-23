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
    var imageUrl: String
    let service = Service()
    private var cancellableStorage = Set<AnyCancellable>()
    typealias T = ImageViewModel.ImageItem
    
    init(imageURL: String){
        self.imageUrl = imageURL
        self.publishersSystem(state)
        .assign(to: \.state, on: self)
        .store(in: &cancellableStorage)
    }
    
    deinit {
        cancellableStorage.removeAll()
    }
    
}

extension ImageViewModel: Loadable {
    var fetch: AnyPublisher<T, Error>{
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
