//
//  ImageViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//
import Combine
import UIKit

class ImageViewModel: ObservableObject{
    @Published private(set) var state = State.idle
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
        case idle
        case loading
        case loaded(UIImage)
        case failedLoaded(Error)
    }
}


extension ImageViewModel {
    func loadImage(_ urlString: String){
        state = .loading
        let request = URLRequest(url: URL(string: baseURL + urlString)!).get()
        cancellable = service.fetchImage(request)
            .sinkToResult({ result in
            switch result{
                case .success(let image):
                    self.state = .loaded(image)
                    break
                case .failure(let error):
                    self.state = .failedLoaded(error)
                    Helper.printFailure(error)
                    break
                }
            })
    }
}
