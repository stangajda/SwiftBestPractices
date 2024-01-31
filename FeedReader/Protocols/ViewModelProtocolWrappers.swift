//
//  ViewModelsProtocolWrappers.swift
//  FeedReader
//
//  Created by Stan Gajda on 07/06/2023.
//

import Foundation
import Combine

// MARK: - BaseViewModelWrapper
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

// MARK: - MoviesListViewModelWrapper
class AnyMoviesListViewModelProtocol: BaseViewModelWrapper<MoviesListViewModel.State, MoviesListViewModel.Action>,
    MoviesListViewModelProtocol {
    typealias ViewModel = MoviesListViewModel
    typealias GENERIC_RES_TYPE = [ViewModel.MovieItem]

    fileprivate var viewModel: any MoviesListViewModelProtocol

    init<ViewModel: MoviesListViewModelProtocol>(_ viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(state: viewModel.state,
                   input: viewModel.input,
                   statePublisher: viewModel.statePublisher)
    }

    func onAppear() {
        viewModel.onAppear()
    }

    func onDisappear() {
        viewModel.onDisappear()
    }

    func onActive() {
        viewModel.onActive()
    }

    func onBackground() {
        viewModel.onBackground()
    }

    func fetch() -> AnyPublisher<GENERIC_RES_TYPE, Error> {
        viewModel.fetch()
    }
}

// MARK: - MovieDetailViewModelWrapper
class AnyMovieDetailViewModelProtocol: BaseViewModelWrapper<MovieDetailViewModel.State, MovieDetailViewModel.Action>,
    MovieDetailViewModelProtocol {
    typealias ViewModel = MovieDetailViewModel
    typealias GENERIC_RES_TYPE = ViewModel.MovieDetailItem

    fileprivate var viewModel: any MovieDetailViewModelProtocol

    init<ViewModel: MovieDetailViewModelProtocol>(_ viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(state: viewModel.state,
                   input: viewModel.input,
                   statePublisher: viewModel.statePublisher)
    }

    func onAppear() {
        viewModel.onAppear()
    }

    func onDisappear() {
        viewModel.onDisappear()
    }

    var movieList: MoviesListViewModel.MovieItem {
        viewModel.movieList
    }

    func fetch() -> AnyPublisher<GENERIC_RES_TYPE, Error> {
        viewModel.fetch()
    }
}

// MARK: - ImageWrapper
class AnyImageViewModelProtocol: BaseViewModelWrapper<ImageViewModel.State, ImageViewModel.Action>,
    ImageViewModelProtocol {
    typealias ViewModel = ImageViewModel
    typealias GENERIC_REQ_TYPE = String
    typealias GENERIC_RES_TYPE = ViewModel.ImageItem

    fileprivate var viewModel: any ImageViewModelProtocol

    init<ViewModel: ImageViewModelProtocol>(_ viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(state: viewModel.state,
                   input: viewModel.input,
                   statePublisher: viewModel.statePublisher)
    }

    func onAppear() {
        viewModel.onAppear()
    }

    func onDisappear() {
        viewModel.onDisappear()
    }

    func fetch() -> AnyPublisher<GENERIC_RES_TYPE, Error> {
        viewModel.fetch()
    }

}

// MARK: - EraseToAnyViewModel
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

extension ImageViewModelProtocol {
    func eraseToAnyViewModelProtocol() -> AnyImageViewModelProtocol {
        return AnyImageViewModelProtocol(self)
    }
}
