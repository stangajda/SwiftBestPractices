//
//  Swinject.swift
//  FeedReader
//
//  Created by Stan Gajda on 22/05/2023.
//

import Foundation
import Swinject

protocol InjectionRegistering {
    func initialRegistration()
}

// MARK:- Injection
public final class Injection: InjectionRegistering  {
    private static let shared = Injection()
    private let container = Container()
    private lazy var assembler = Assembler()
    public static var resolver: Container {
        Injection.shared.container
    }
    public static var main: Injection{
        Injection.shared
    }
}

extension Injection {
    public func initialRegistration() {
        assembler = Assembler(
        [
            NetworkAssembly(),
            ServiceAssembly(),
            ViewModelAssembly()
        ],
        container: container)
    }
    
    func setupTestURLSession() {
        assembler = Assembler(
        [
            MockNetworkAssembly(),
            ServiceAssembly(),
            ViewModelAssembly()
        ],
        container: container)
    }
    
    func setupPreviewMode() {
        assembler = Assembler(
        [
            MockNetworkAssembly(),
            ServiceAssembly(),
            MockMoviesListViewModelAssembly(),
            MockMovieDetailViewModelAssembly(),
            MockImageViewModelAssembly()
        ],
        container: container)
    }
    
    func setupPreviewModeDetail() {
        assembler = Assembler(
        [
            MockNetworkAssembly(),
            ServiceAssembly(),
            MockMoviesListViewModelAssembly(),
            MockImageViewModelItemDetailAssembly(),
            MockImageViewModelItemDetailAssembly()
        ],
        container: container)
    }
}

// MARK:- Session
fileprivate class NetworkAssembly: AssemblyProtocol {
    func assemble(container: Container) {
        container.register(URLSessionProtocol.self) { _ in
            URLSession.configuredURLSession()
        }
    }
}

// MARK:- Service
fileprivate class ServiceAssembly: AssemblyProtocol {
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

// MARK:- ViewModel
fileprivate class ViewModelAssembly: AssemblyProtocol {
    func assemble(container: Container) {
        container.register(AnyMoviesListViewModelProtocol.self) { _ in
            MoviesListViewModel()
                .eraseToAnyViewModelProtocol()
        }
        
        container.register(AnyMovieDetailViewModelProtocol.self) { resolver , movie in
            MovieDetailViewModel.instance(movie)
                .eraseToAnyViewModelProtocol()
        }
        
        container.register(AnyImageViewModelProtocol.self) { resolver , imagePath, imageSizePath, cache in
            ImageViewModel.instance(imagePath: imagePath, imageSizePath: imageSizePath, cache: cache)
                .eraseToAnyViewModelProtocol()
        }
    }
}

// MARK:- Preview
fileprivate class MockMoviesListViewModelAssembly: AssemblyNameProtocol {
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
        
        register(AnyMovieDetailViewModelProtocol.self, container: container) { resolver, movie in
            MockMovieDetailViewModel(movie)
                .eraseToAnyViewModelProtocol()
        }
    }
}

fileprivate class MockMovieDetailViewModelAssembly: AssemblyNameProtocol {
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

fileprivate class MockImageViewModelAssembly: AssemblyProtocol {
    func assemble(container: Container) {
        container.register(AnyImageViewModelProtocol.self) { resolver , imagePath, imageSizePath, cache in
            MockImageViewModel(imagePath: imagePath, imageSizePath: imageSizePath, cache: cache)
                .eraseToAnyViewModelProtocol()
        }
    }
    
}

fileprivate class MockImageViewModelItemDetailAssembly: AssemblyProtocol {
    func assemble(container: Container) {
        container.register(AnyImageViewModelProtocol.self) { resolver , imagePath, imageSizePath, cache in
            MockImageViewModelDetail(imagePath: imagePath, imageSizePath: imageSizePath, cache: cache)
                .eraseToAnyViewModelProtocol()
        }
    }
}

fileprivate class MockNetworkAssembly: AssemblyProtocol {
    func assemble(container: Container) {
        container.register(URLSessionProtocol.self) { _ in
            URLSession.mockURLSession()
        }.inObjectScope(.container)
    }
}

// MARK:- Injection.Name
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


