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

        container.register(MovieDetailServiceProtocol.self) { resolver in
            MockMovieDetailService()
        }

        container.register(ImageServiceProtocol.self) { resolver in
            MockImageService()
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

        register(AnyMoviesListViewModelProtocol.self, container: container, name: .movieListStateLoading) { resolver in
            MockMoviesListViewModel(.loading)
                .eraseToAnyViewModelProtocol()
        }

        register(AnyMoviesListViewModelProtocol.self, container: container, name: .movieListStateFailed) { resolver in
            MockMoviesListViewModel(.failedLoaded)
                .eraseToAnyViewModelProtocol()
        }
    }
}

class MockMovieDetailViewModelAssembly: AssemblyNameProtocol {
    func assemble(container: Container) {
        register(AnyMovieDetailViewModelProtocol.self, container: container, name: .movieDetailStateLoaded) { resolver in
            MockMovieDetailViewModel(.loaded, MoviesListViewModel.MovieItem.mock)
                .eraseToAnyViewModelProtocol()
        }

        register(AnyMovieDetailViewModelProtocol.self, container: container, name: .movieDetailStateLoading) { resolver in
            MockMovieDetailViewModel(.loading, MoviesListViewModel.MovieItem.mock)
                .eraseToAnyViewModelProtocol()
        }

        register(AnyMovieDetailViewModelProtocol.self, container: container, name: .movieDetailStateFailed) { resolver in
            MockMovieDetailViewModel(.failedLoaded, MoviesListViewModel.MovieItem.mock)
                .eraseToAnyViewModelProtocol()
        }
    }
}

class MockImageViewModelAssembly: AssemblyProtocol {
    func assemble(container: Container) {
        container.register(AnyImageViewModelProtocol.self) { resolver , imagePath, imageSizePath in
            MockImageViewModel(imagePath: imagePath, imageSizePath: imageSizePath)
                .eraseToAnyViewModelProtocol()
        }
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

class MockNetworkAssembly: AssemblyProtocol {
    func assemble(container: Container) {
        container.register(URLSessionProtocol.self) { _ in
            URLSession.mock
        }.inObjectScope(.container)
    }
}
