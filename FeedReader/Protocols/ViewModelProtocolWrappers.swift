//
//  ViewModelsProtocolWrappers.swift
//  FeedReader
//
//  Created by Stan Gajda on 07/06/2023.
//

import Foundation
import Combine

//MARK: - BaseViewModelWrapper
class BaseViewModelWrapper<StateType, ActionType> {
    @Published var state: StateType
    var input: PassthroughSubject<ActionType, Never>
    
    fileprivate(set) var statePublisher: Published<StateType>.Publisher
    
    fileprivate var cancellable: AnyCancellable?
    
    init(state: StateType,
         input: PassthroughSubject<ActionType, Never>,
         statePublisher: Published<StateType>.Publisher) {
        self.state = state
        self.input = input
        self.statePublisher = statePublisher
        
        cancellable = statePublisher.sink { [weak self] newState in
            self?.state = newState
        }
    }
}

//MARK: - MoviesListViewModelWrapper
class AnyMoviesListViewModelProtocol: BaseViewModelWrapper<MoviesListViewModel.State, MoviesListViewModel.Action>, MoviesListViewModelProtocol {
    typealias ViewModel = MoviesListViewModel
    typealias T = Array<ViewModel.MovieItem>
    
    fileprivate var viewModel: any MoviesListViewModelProtocol
    
    init<ViewModel: MoviesListViewModelProtocol>(_ viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(state: viewModel.state,
                   input: viewModel.input,
                   statePublisher: viewModel.statePublisher)
    }
    
    func fetch() -> AnyPublisher<T, Error> {
        viewModel.fetch()
    }
    
    func onResetAction() {
        viewModel.onResetAction()
    }
}

//MARK: - MovieDetailViewModelWrapper
class AnyMovieDetailViewModelProtocol: BaseViewModelWrapper<MovieDetailViewModel.State, MovieDetailViewModel.Action>, MovieDetailViewModelProtocol {
    typealias ViewModel = MovieDetailViewModel
    typealias T = ViewModel.MovieDetailItem
    
    fileprivate var viewModel: any MovieDetailViewModelProtocol
    
    init<ViewModel: MovieDetailViewModelProtocol>(_ viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(state: viewModel.state,
                   input: viewModel.input,
                   statePublisher: viewModel.statePublisher)
    }
    
    var movieList: MoviesListViewModel.MovieItem {
        get { viewModel.movieList }
    }

    
    func fetch() -> AnyPublisher<T, Error> {
        viewModel.fetch()
    }
    
    func onResetAction() {
        viewModel.onResetAction()
    }
}

//MARK: - ImageWrapper
class AnyImageViewModelProtocol: BaseViewModelWrapper<ImageViewModel.State, ImageViewModel.Action>, ImageViewModelProtocol {
    typealias ViewModel = ImageViewModel
    typealias T = ViewModel.ImageItem
    typealias U = String
    
    fileprivate var viewModel: any ImageViewModelProtocol
    
    init<ViewModel: ImageViewModelProtocol>(_ viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(state: viewModel.state,
                   input: viewModel.input,
                   statePublisher: viewModel.statePublisher)
    }
    
    func fetch() -> AnyPublisher<T, Error> {
        viewModel.fetch()
    }
    
    func onResetAction() {
        viewModel.onResetAction()
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

