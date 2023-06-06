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
        assembler = Assembler([NetworkAssembly(), ServiceAssembly(), ViewModelAssembly()], container: container)
    }
    
    func setupTestURLSession() {
        assembler = Assembler([MockNetworkAssembly(), ServiceAssembly(), ViewModelAssembly()], container: container)
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
            AnyMoviesListViewModelProtocol(MoviesListViewModel())
        }
        
        container.register(AnyMovieDetailViewModelProtocol.self) { resolver , movie in
            AnyMovieDetailViewModelProtocol(MovieDetailViewModel.instance(movie))
        }
        
        container.register(AnyImageViewModelProtocol.self) { resolver , imagePath, imageSizePath, cache in
            AnyImageViewModelProtocol(ImageViewModel.instance(imagePath: imagePath, imageSizePath: imageSizePath, cache: cache))
        }
    }
}

// MARK:- Preview
fileprivate class MockMoviesListViewModeLAssembly: AssemblyNameProtocol {
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
        
        register(AnyMovieDetailViewModelProtocol.self, container: container) { resolver, movie in
            AnyMovieDetailViewModelProtocol(MockMovieDetailViewModel(movie))
        }
    }
}

fileprivate class MockMovieDetailViewModelAssembly: AssemblyNameProtocol {
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

fileprivate class MockImageViewModelAssembly: AssemblyProtocol {
    func assemble(container: Container) {
        container.register(AnyImageViewModelProtocol.self) { resolver , imagePath, imageSizePath, cache in
            AnyImageViewModelProtocol(MockImageViewModel(imagePath: imagePath, imageSizePath: imageSizePath, cache: cache))
        }
    }
    
}

fileprivate class MockImageViewModelItemDetailAssembly: AssemblyProtocol {
    func assemble(container: Container) {
        container.register(AnyImageViewModelProtocol.self) { resolver , imagePath, imageSizePath, cache in
            AnyImageViewModelProtocol(MockImageViewModelDetail(imagePath: imagePath, imageSizePath: imageSizePath, cache: cache))
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


