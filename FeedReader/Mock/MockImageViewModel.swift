//
//  MockImageViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 23/07/2021.
//

import Foundation
import UIKit
import Combine

//class MockImageViewModel: ImageViewModel{
//    var image: UIImage?
//    enum MockState {
//        case itemList
//        case itemDetail
//    }
//    override var state: State{
//        guard let image = image else {
//            return .start()
//        }
//        return .loaded(ImageItem(image))
//    }
//    
//    init(_ state: MockState){
//        super.init(imagePath: "mockUrl", imageSizePath: OriginalPath())
//        switchState(state)
//    }
//    
//    func switchState(_ state: MockState){
//        switch state {
//        case .itemList:
//            image = UIImage(named: "stubImageMovieMedium")
//        case .itemDetail:
//            image = UIImage(named: "stubImageMovieDetailsBig")
//        }
//    }
//}

class MockMovieDetailViewModelLoaded2: MovieDetailViewModelProtocol {
    var movieList: MoviesListViewModel.MovieItem
    var state: MovieDetailViewModel.State = .loaded(MovieDetailViewModel.MovieDetailItem(MovieDetail.mock))
    var input = PassthroughSubject<MovieDetailViewModel.Action, Never>()
    var fetch: AnyPublisher<MovieDetailViewModel.MovieDetailItem, Error>
    
    init(movieList: MoviesListViewModel.MovieItem){
        self.movieList = movieList
        self.fetch = Just(MovieDetailViewModel.MovieDetailItem(MovieDetail.mock))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

class MockImageViewModelLoaded: ImageViewModelProtocol {
    typealias T = ImageViewModel.ImageItem
    typealias U = String
    
    var state: ImageViewModel.State = .loaded(ImageViewModel.ImageItem(UIImage(named: "stubImageMovieDetailsBig")!))
    var input = PassthroughSubject<ImageViewModel.Action, Never>()
    var fetch: AnyPublisher<ImageViewModel.ImageItem, Error>
    
    init(){
        self.fetch = Just(ImageViewModel.ImageItem(UIImage(named: "stubImageMovieDetailsBig")!))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
