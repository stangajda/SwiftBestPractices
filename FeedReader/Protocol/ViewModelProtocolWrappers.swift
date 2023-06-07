//
//  ViewModelsProtocolWrappers.swift
//  FeedReader
//
//  Created by Stan Gajda on 07/06/2023.
//

import Foundation
import Combine

//MARK: - oviesListViewModelWrapper
class AnyMoviesListViewModelProtocol: MoviesListViewModelProtocol {
    @Published var state: ViewModel.State
    var input: PassthroughSubject<ViewModel.Action, Never>
    
    fileprivate(set) var statePublisher: Published<State>.Publisher
    typealias ViewModel = MoviesListViewModel
    typealias T = Array<ViewModel.MovieItem>
    
    fileprivate var viewModel: any MoviesListViewModelProtocol

    fileprivate var cancellable: AnyCancellable?
    init<ViewModel: MoviesListViewModelProtocol>(_ viewModel: ViewModel) {
        state = viewModel.state
        input = viewModel.input
        self.viewModel = viewModel
        statePublisher = viewModel.statePublisher
        cancellable = viewModel.statePublisher.sink { [weak self] newState in
            self?.state = newState
        }
    }
    
    func fetch() -> AnyPublisher<T, Error> {
        viewModel.fetch()
    }
    
}



//MARK: - MovieDetailViewModelWrapper
class AnyMovieDetailViewModelProtocol: MovieDetailViewModelProtocol {
    @Published var state: ViewModel.State
    var input: PassthroughSubject<ViewModel.Action, Never>
    var movieList: MoviesListViewModel.MovieItem
    
    fileprivate(set) var statePublisher: Published<State>.Publisher
    
    typealias ViewModel = MovieDetailViewModel
    typealias T = ViewModel.MovieDetailItem
    
    fileprivate var viewModel: any MovieDetailViewModelProtocol

    fileprivate var cancellable: AnyCancellable?
    init<ViewModel: MovieDetailViewModelProtocol>(_ viewModel: ViewModel) {
        state = viewModel.state
        input = viewModel.input
        self.viewModel = viewModel
        movieList = viewModel.movieList
        statePublisher = viewModel.statePublisher
        
        cancellable = viewModel.statePublisher.sink { [weak self] newState in
            self?.state = newState
        }
    }
    
    func fetch() -> AnyPublisher<ViewModel.MovieDetailItem, Error> {
        viewModel.fetch()
    }
}

//MARK: - ImageWrapper
class AnyImageViewModelProtocol: ImageViewModelProtocol{
    @Published var state: ViewModel.State
    var input: PassthroughSubject<ViewModel.Action, Never>
    
    fileprivate(set) var statePublisher: Published<State>.Publisher
    
    typealias ViewModel = ImageViewModel
    
    typealias State = LoadableEnums<T,U>.State
    typealias T = ViewModel.ImageItem
    typealias U = String
    
    fileprivate var viewModel: any ImageViewModelProtocol

    
    fileprivate var cancellable: AnyCancellable?
    init<ViewModel: ImageViewModelProtocol>(_ viewModel: ViewModel){
        state = viewModel.state
        input = viewModel.input
        statePublisher = viewModel.statePublisher
        self.viewModel = viewModel
        cancellable = viewModel.statePublisher.sink { [weak self] newState in
            self?.state = newState
        }
    }
    
    func fetch() -> AnyPublisher<ViewModel.ImageItem, Error> {
        return viewModel.fetch()
    }
    
}

//MARK: - EraseToAnyViewModel
extension MovieDetailViewModelProtocol {
    func eraseToAnyViewModelProtocol() -> AnyMovieDetailViewModelProtocol {
        AnyMovieDetailViewModelProtocol(self)
    }
}

extension MoviesListViewModelProtocol {
    func eraseToAnyViewModelProtocol() -> AnyMoviesListViewModelProtocol {
        AnyMoviesListViewModelProtocol(self)
    }
}

extension ImageViewModelProtocol{
    func eraseToAnyViewModelProtocol() -> AnyImageViewModelProtocol{
        return AnyImageViewModelProtocol(self)
    }
}

