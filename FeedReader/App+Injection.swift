//
//  Swinject.swift
//  FeedReader
//
//  Created by Stan Gajda on 22/05/2023.
//

import Foundation
import Swinject

extension Injection {
    func initialSetup(){
        assembler = Assembler([NetworkAssembly(), ServiceAssembly(), ViewModelAssembly()], container: container)
    }
    
    func setupPreviewMode() {
        assembler.apply(assembly: MockMoviesListViewModeLAssembly())
        assembler.apply(assembly: MockMovieDetailViewModelAssembly())
        assembler.apply(assembly: MockImageViewModelAssembly())
    }
    
    func setupPreviewModeDetail() {
        assembler.apply(assembly: MockMovieDetailViewModelAssembly())
        assembler.apply(assembly: MockImageViewModelItemDetailAssembly())
    }
}

fileprivate class NetworkAssembly: Assembly {
    func assemble(container: Container) {
        container.register(URLSessionProtocol.self) { _ in
            URLSession.configuredURLSession()
        }
    }
}

fileprivate class ServiceAssembly: Assembly {
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

fileprivate class ViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AnyMoviesListViewModelProtocol.self) { _ in
            AnyMoviesListViewModelProtocol(MoviesListViewModel())
        }
        
        container.register(AnyMovieDetailViewModelProtocol.self) { resolver , movie in
            AnyMovieDetailViewModelProtocol(MovieDetailViewModel(movieList: movie))
        }
        
        container.register(AnyImageViewModelProtocol.self) { resolver , imagePath, imageSizePath, cache in
            AnyImageViewModelProtocol(ImageViewModel(imagePath: imagePath, imageSizePath: imageSizePath, cache: cache))
        }
    }
}

fileprivate class MockMoviesListViewModeLAssembly: AssemblyProtocol {
    func assemble(container: Container) {
        register(AnyMoviesListViewModelProtocol.self, container: container, name: .movieListStateLoaded) { resolver in
            AnyMoviesListViewModelProtocol(MockMoviesListViewModel(.loaded))
        }

        register(AnyMoviesListViewModelProtocol.self, container: container, name: .movieListStateLoading) { resolver in
            AnyMoviesListViewModelProtocol(MockMoviesListViewModel(.loading))
        }

        register(AnyMoviesListViewModelProtocol.self, container: container, name: .movieListStateFailed) { resolver in
            AnyMoviesListViewModelProtocol(MockMoviesListViewModel(.failedLoaded))
        }
    }
}

fileprivate class MockMovieDetailViewModelAssembly: AssemblyProtocol {
    func assemble(container: Container) {
        register(AnyMovieDetailViewModelProtocol.self, container: container, name: .movieDetailStateLoaded) { resolver in
            AnyMovieDetailViewModelProtocol(MockMovieDetailViewModel(.loaded, MoviesListViewModel.MovieItem.mock))
        }

        register(AnyMovieDetailViewModelProtocol.self, container: container, name: .movieDetailStateLoading) { resolver in
            AnyMovieDetailViewModelProtocol(MockMovieDetailViewModel(.loading, MoviesListViewModel.MovieItem.mock))
        }

        register(AnyMovieDetailViewModelProtocol.self, container: container, name: .movieDetailStateFailed) { resolver in
            AnyMovieDetailViewModelProtocol(MockMovieDetailViewModel(.failedLoaded, MoviesListViewModel.MovieItem.mock))
        }
    }
}

fileprivate class MockImageViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AnyImageViewModelProtocol.self) { resolver , imagePath, imageSizePath, cache in
            AnyImageViewModelProtocol(MockImageViewModel(imagePath: imagePath, imageSizePath: imageSizePath, cache: cache))
        }
    }
    
}

fileprivate class MockImageViewModelItemDetailAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AnyImageViewModelProtocol.self) { resolver , imagePath, imageSizePath, cache in
            AnyImageViewModelProtocol(MockImageViewModelDetail(imagePath: imagePath, imageSizePath: imageSizePath, cache: cache))
        }
    }
}

extension Injection.Name {
    
    static let movieListStateLoaded = Self("MovieListStateLoaded")
    static let movieListStateLoading = Self("MovieListStateLoading")
    static let movieListStateFailed = Self("MovieListStateFailed")
    
    static let movieDetailStateLoaded = Self("MovieDetailStateLoaded")
    static let movieDetailStateLoading = Self("MovieDetailStateLoading")
    static let movieDetailStateFailed = Self("MovieDetailStateFailed")
    
    static let imageStateLoaded = Self("ImageStateLoaded")

    static let itemList = Self("ItemList")
    static let itemDetail = Self("ItemDetail")
}


