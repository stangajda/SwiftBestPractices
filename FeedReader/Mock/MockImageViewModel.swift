//
//  MockImageViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 23/07/2021.
//

import Foundation
import UIKit
import Combine

class MockImageViewModelLoaded: ImageViewModelProtocol {
    typealias T = ImageViewModel.ImageItem
    typealias U = String
    
    @Published var state: ImageViewModel.State = .loading()
    var input = PassthroughSubject<ImageViewModel.Action, Never>()
    var fetch: AnyPublisher<ImageViewModel.ImageItem, Error>

    enum MockState {
        case itemList
        case itemDetail
    }
    
    init(_ mockState: MockState = .itemList){
        var image: UIImage?
        switch mockState { 
            case .itemList:
                image = UIImage(named: "stubImageMovieMedium")
            case .itemDetail:
                image = UIImage(named: "stubImageMovieDetailsBig")
        }

        guard let image = image else {
            self.fetch = Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
            return
        }

        self.fetch = Just(ImageViewModel.ImageItem(image))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
