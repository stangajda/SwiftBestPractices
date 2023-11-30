//
//  Assembly.swift
//  FeedReader
//
//  Created by Stan Gajda on 15/07/2023.
//

import Foundation
import Swinject

// MARK: - Session
class NetworkAssembly: AssemblyProtocol {
    func assemble(container: Container) {
        container.register(URLSessionProtocol.self) { _ in
            URLSession.`default`
        }
    }
}

// MARK: - Service
class ServiceAssembly: AssemblyProtocol {
    func assemble(container: Container) {
        container.register(ServiceProtocol.self) { _ in
            Service()
        }

        container.register(MovieListServiceProtocol.self) { _ in
            MovieListService()
        }

        container.register(MovieDetailServiceProtocol.self) { _ in
            MovieDetailService()
        }

        container.register(ImageServiceProtocol.self) { _ in
            ImageService()
        }
    }
}

// MARK: - Mock Service
class MockServiceAssembly: AssemblyProtocol {
    func assemble(container: Container) {
        container.register(MovieListServiceProtocol.self) { _ in
            MockMovieListService()
        }
        container.register(MovieListServiceProtocol.self) { _, argument in
            MockMovieListService(argument)
        }
        container.register(MovieDetailServiceProtocol.self) { _ in
            MockMovieDetailService()
        }
        container.register(MovieDetailServiceProtocol.self) { _, argument in
            MockMovieDetailService(argument)
        }

        container.register(ImageServiceProtocol.self) { _ in
            MockImageService()
        }

        container.register(ImageServiceProtocol.self) { _, argument in
            MockImageService(argument)
        }
    }
}

// MARK: - ViewModel
class ViewModelAssembly: AssemblyProtocol {
    func assemble(container: Container) {
        container.register(AnyMoviesListViewModelProtocol.self) { _ in
            MoviesListViewModel()
                .eraseToAnyViewModelProtocol()
        }
        container.register(AnyMovieDetailViewModelProtocol.self) { _, movie in
            MovieDetailViewModel.instance(movie)
                .eraseToAnyViewModelProtocol()
        }
        container.register(AnyImageViewModelProtocol.self) { _, imagePath, imageSizePath in
            ImageViewModel.instance(imagePath: imagePath, imageSizePath: imageSizePath)
                .eraseToAnyViewModelProtocol()
        }
        container.register(AnyImageViewModelProtocol.self) { _, imagePath, imageSizePath, cache in
            ImageViewModel.instance(imagePath: imagePath, imageSizePath: imageSizePath, cache: cache)
                .eraseToAnyViewModelProtocol()
        }
    }
}

// MARK: - Preview
class MockMoviesListViewModelAssembly: AssemblyNameProtocol {
    func assemble(container: Container) {
        container.register(AnyMoviesListViewModelProtocol.self) { _ in
            MockMoviesListViewModel(.loaded)
                .eraseToAnyViewModelProtocol()
        }

        register(AnyMoviesListViewModelProtocol.self, container: container, name: .movieListStateLoaded) { _ in
            MockMoviesListViewModel(.loaded)
                .eraseToAnyViewModelProtocol()
        }
        register(AnyMoviesListViewModelProtocol.self, container: container, name: .movieListStateStart) { _ in
            MockMoviesListViewModel(.start)
                .eraseToAnyViewModelProtocol()
        }
        register(AnyMoviesListViewModelProtocol.self, container: container, name: .movieListStateLoading) { _ in
            MockMoviesListViewModel(.loading)
                .eraseToAnyViewModelProtocol()
        }
        register(AnyMoviesListViewModelProtocol.self, container: container, name: .movieListStateFailed) { _ in
            MockMoviesListViewModel(.failedLoaded)
                .eraseToAnyViewModelProtocol()
        }
        register(AnyMovieDetailViewModelProtocol.self, container: container ) { _, movie in
            MockMovieDetailViewModel(movie)
                .eraseToAnyViewModelProtocol()
        }

    }
}

class MockMovieDetailViewModelAssembly: AssemblyNameProtocol {
    func assemble(container: Container) {
        container.register(AnyMovieDetailViewModelProtocol.self) { _ in
            MockMovieDetailViewModel(MoviesListViewModel.MovieItem.mock)
                .eraseToAnyViewModelProtocol()
        }

        register(AnyMovieDetailViewModelProtocol.self, container: container, name: .movieDetailStateLoaded) { _ in
            MockMovieDetailViewModel(MoviesListViewModel.MovieItem.mock)
                .eraseToAnyViewModelProtocol()
        }
        register(AnyMovieDetailViewModelProtocol.self, container: container, name: .movieDetailStateStart) { _ in
            MockMovieDetailViewModel(MoviesListViewModel.MovieItem.mock, .start)
                .eraseToAnyViewModelProtocol()
        }

        register(AnyMovieDetailViewModelProtocol.self, container: container, name: .movieDetailStateLoading) { _ in
            MockMovieDetailViewModel(MoviesListViewModel.MovieItem.mock, .loading)
                .eraseToAnyViewModelProtocol()
        }
        register(AnyMovieDetailViewModelProtocol.self, container: container, name: .movieDetailStateFailed) { _ in
            MockMovieDetailViewModel(MoviesListViewModel.MovieItem.mock, .failedLoaded)
                .eraseToAnyViewModelProtocol()
        }
    }
}

class MockImageViewModelAssembly: AssemblyProtocol {
    func assemble(container: Container) {
        container.register(AnyImageViewModelProtocol.self) { _, imagePath, imageSizePath, cache in
            MockImageViewModel(imagePath: imagePath, imageSizePath: imageSizePath, cache: cache)
                .eraseToAnyViewModelProtocol()
        }
    }
}

class MockImageViewModelItemDetailAssembly: AssemblyProtocol {
    func assemble(container: Container) {
        container.register(AnyImageViewModelProtocol.self) { _, imagePath, imageSizePath, cache in
            MockImageViewModelDetail(imagePath: imagePath, imageSizePath: imageSizePath, cache: cache)
                .eraseToAnyViewModelProtocol()
        }
    }
}

class MockFailedImageViewModelAssembly: AssemblyProtocol {
    func assemble(container: Container) {
        container.register(AnyImageViewModelProtocol.self) { _, imagePath, imageSizePath, cache in
            MockFailedImageViewModel(imagePath: imagePath, imageSizePath: imageSizePath, cache: cache)
                .eraseToAnyViewModelProtocol()
        }
    }
}

class MockNetworkAssembly: AssemblyProtocol {
    func assemble(container: Container) {
        container.register(URLSessionProtocol.self) { _ in
            URLSession.mock
        }
        container.register(NetworkResponseProtocol.self) { _, result in
            MockNetworkRequest(result as Result<Movies, Error>)
        }
        container.register(NetworkResponseProtocol.self) { _, result in
            MockNetworkRequest(result as Result<MovieDetail, Error>)
        }
        container.register(NetworkResponseProtocol.self) { _, result in
            MockNetworkRequest(result as Result<Data, Error>)
        }
    }
}
