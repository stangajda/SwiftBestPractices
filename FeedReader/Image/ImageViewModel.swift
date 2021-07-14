//
//  ImageViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 14/07/2021.
//
import Combine
import SwiftUI

class ImageService: ObservableObject{
    @Published var image: UIImage?
    
    let service = Service()
    var cancellable: AnyCancellable?
    
    init(){
    }
    
    func loadImage(_ urlString: String){
        let request = URLRequest(url: URL(string: urlString)!).get()
        cancellable = service.fetchImage(request)
            .sinkToResult({ result in
            switch result{
                case .success(let image):
                    self.image = image
                    break
                case .failure(let error):
                    Helper.printFailure(error)
                    break
                }
            })
    }
}
