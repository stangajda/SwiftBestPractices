//
//  ImageViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//
import Combine
import UIKit
import SwiftUI

class ImageViewModel: ObservableObject{
    @Published private(set) var state = State.initial
    private let baseURL = "https://image.tmdb.org/t/p/original"
    
    let service = Service()
    var cancellable: AnyCancellable?
    
    init(){
    }
    
    func onAppear(url: String){
        state = .loading
        loadImage(url)
    }
}

extension ImageViewModel{
    enum State {
        case initial
        case loading
        case loaded(Image)
        case failedLoaded(Error)
    }
    
    struct ImageItem{
        let image: Image
        init(_ uiImage: UIImage) {
            image = Image(uiImage: uiImage)
        }
    }
}


extension ImageViewModel {
    func loadImage(_ urlString: String){
        state = .loading
        let request = URLRequest(url: URL(string: baseURL + urlString)!).get()
        cancellable = service.fetchImage(request)
            .map { item in
                ImageItem(item)
            }
            .sinkToResult({ [unowned self] result in
            switch result{
                case .success(let item):
                    self.state = .loaded(item.image)
                    break
                case .failure(let error):
                    self.state = .failedLoaded(error)
                    Helper.printFailure(error)
                    break
                }
            })
    }
}
