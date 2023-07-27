//
//  Assembly.swift
//  FeedReader
//
//  Created by Stan Gajda on 15/07/2023.
//

import Foundation
import Swinject

// MARK:- Session
class NetworkAssembly: AssemblyProtocol {
    func assemble(container: Container) {
        container.register(URLSessionProtocol.self) { _ in
            URLSession.`default`
        }
    }
}

// MARK:- Service
class ServiceAssembly: AssemblyProtocol {
    func assemble(container: Container) {
        container.register(ServiceProtocol.self) { resolver in
            Service()
        }
        
        container.register(MovieListServiceProtocol.self) { resolver in
            MovieListService()
        }
        
        container.register(MovieDetailServiceProtocol.self) { resolver in
            MovieDetailService()
        }
        
        container.register(ImageServiceProtocol.self) { resolver in
            ImageService()
        }
    }
}

// MARK:- Mock Service
class MockServiceAssembly: AssemblyProtocol {
    func assemble(container: Container) {
        container.register(MovieListServiceProtocol.self) { resolver in
            MockMovieListService()
        }
        
        container.register(MovieListServiceProtocol.self) { resolver, argument in
            MockMovieListService(argument)
        }
        
        container.register(MovieDetailServiceProtocol.self) { resolver in
            MockMovieDetailService()
        }

        container.register(MovieDetailServiceProtocol.self) { resolver, argument in
            MockMovieDetailService(argument)
        }

        container.register(ImageServiceProtocol.self) { resolver in
            MockImageService()
        }

        container.register(ImageServiceProtocol.self) { resolver, argument in
            MockImageService(argument)
        }
    }
}

// MARK:- ViewModel
class ViewModelAssembly: AssemblyProtocol {
    func assemble(container: Container) {
        container.register(AnyMoviesListViewModelProtocol.self) { _ in
            MoviesListViewModel()
                .eraseToAnyViewModelProtocol()
        }
        
        container.register(AnyMovieDetailViewModelProtocol.self) { resolver , movie in
            MovieDetailViewModel.instance(movie)
                .eraseToAnyViewModelProtocol()
        }
        
        container.register(AnyImageViewModelProtocol.self) { resolver , imagePath, imageSizePath in
            ImageViewModel.instance(imagePath: imagePath, imageSizePath: imageSizePath)
                .eraseToAnyViewModelProtocol()
        }
        
        container.register(AnyImageViewModelProtocol.self) { resolver , imagePath, imageSizePath, cache in
            ImageViewModel.instance(imagePath: imagePath, imageSizePath: imageSizePath, cache: cache)
                .eraseToAnyViewModelProtocol()
        }
    }
}

// MARK:- Preview
class MockMoviesListViewModelAssembly: AssemblyNameProtocol {
    func assemble(container: Container) {
        container.register(AnyMoviesListViewModelProtocol.self) { resolver in
            MockMoviesListViewModel(.loaded)
                .eraseToAnyViewModelProtocol()
        }

        register(AnyMoviesListViewModelProtocol.self, container: container, name: .movieListStateLoaded) { resolver in
            MockMoviesListViewModel(.loaded)
                .eraseToAnyViewModelProtocol()
        }
        
        register(AnyMoviesListViewModelProtocol.self, container: container, name: .movieListStateStart) { resolver in
            MockMoviesListViewModel(.start)
                .eraseToAnyViewModelProtocol()
        }

        register(AnyMoviesListViewModelProtocol.self, container: container, name: .movieListStateLoading) { resolver in
            MockMoviesListViewModel(.loading)
                .eraseToAnyViewModelProtocol()
        }

        register(AnyMoviesListViewModelProtocol.self, container: container, name: .movieListStateFailed) { resolver in
            MockMoviesListViewModel(.failedLoaded)
                .eraseToAnyViewModelProtocol()
        }
        
        register(AnyMovieDetailViewModelProtocol.self, container: container ) { resolver, movie in
            MockMovieDetailViewModel(movie)
                .eraseToAnyViewModelProtocol()
        }

    }
}

class MockMovieDetailViewModelAssembly: AssemblyNameProtocol {
    func assemble(container: Container) {
        container.register(AnyMovieDetailViewModelProtocol.self) { resolver in
            MockMovieDetailViewModel(MoviesListViewModel.MovieItem.mock)
                .eraseToAnyViewModelProtocol()
        }

        register(AnyMovieDetailViewModelProtocol.self, container: container, name: .movieDetailStateLoaded) { resolver in
            MockMovieDetailViewModel(MoviesListViewModel.MovieItem.mock)
                .eraseToAnyViewModelProtocol()
        }
        
        register(AnyMovieDetailViewModelProtocol.self, container: container, name: .movieDetailStateStart) { resolver in
            MockMovieDetailViewModel(MoviesListViewModel.MovieItem.mock, .start)
                .eraseToAnyViewModelProtocol()
        }

        register(AnyMovieDetailViewModelProtocol.self, container: container, name: .movieDetailStateLoading) { resolver in
            MockMovieDetailViewModel(MoviesListViewModel.MovieItem.mock, .loading)
                .eraseToAnyViewModelProtocol()
        }

        register(AnyMovieDetailViewModelProtocol.self, container: container, name: .movieDetailStateFailed) { resolver in
            MockMovieDetailViewModel(MoviesListViewModel.MovieItem.mock, .failedLoaded)
                .eraseToAnyViewModelProtocol()
        }
    }
}

class MockImageViewModelAssembly: AssemblyProtocol {
    func assemble(container: Container) {
        container.register(AnyImageViewModelProtocol.self) { resolver , imagePath, imageSizePath, cache in
            MockImageViewModel(imagePath: imagePath, imageSizePath: imageSizePath, cache: cache)
                .eraseToAnyViewModelProtocol()
        }
    }
    
}

class MockImageViewModelItemDetailAssembly: AssemblyProtocol {
    func assemble(container: Container) {
        container.register(AnyImageViewModelProtocol.self) { resolver , imagePath, imageSizePath, cache in
            MockImageViewModelDetail(imagePath: imagePath, imageSizePath: imageSizePath, cache: cache)
                .eraseToAnyViewModelProtocol()
        }
    }
}

class MockFailedImageViewModelAssembly: AssemblyProtocol {
    func assemble(container: Container) {
        container.register(AnyImageViewModelProtocol.self) { resolver , imagePath, imageSizePath, cache in
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
        container.register(NetworkResponseProtocol.self) { resolver, result in
            MockNetworkRequest(result as Result<Movies, Error>)
        }
        container.register(NetworkResponseProtocol.self) { resolver, result in
            MockNetworkRequest(result as Result<MovieDetail, Error>)
        }
        container.register(NetworkResponseProtocol.self) { resolver, result in
            MockNetworkRequest(result as Result<Data, Error>)
        }
    }
}
