//
//  MockmoviesDetailViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 24/07/2021.
//

import Foundation

class MockMovieDetailViewModel: MovieDetailViewModel{
    var internalState: State = .start()
    enum MockState {
        case loading
        case loaded
        case failedLoaded
    }
    
    override var state: State{
        return internalState
    }
    
    init(_ state: MockState){
        super.init(movieList: MockMoviesListViewModel.MovieItem.mock)
        switchState(state)
    }
    
    var mockItems: MovieDetailItem{
        return MovieDetailItem(MovieDetail.mock)
    }
    
    func switchState(_ state:MockState){
        let error = NSError(domain: "AnyDomain", code: 404, userInfo: nil)
        switch state {
        case .loading:
            internalState = .loading()
        case .loaded:
            internalState = .loaded(mockItems)
        case .failedLoaded:
            internalState = .failedLoaded(error)
        }
    }
}
