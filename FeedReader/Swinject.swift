//
//  Swinject.swift
//  FeedReader
//
//  Created by Stan Gajda on 22/05/2023.
//

import Foundation
import Swinject

class DependencyManager {
    static let shared = DependencyManager()
    let container = Container()
    var assembler: Assembler
    
    private init() {
        assembler = Assembler([NetworkAssembly(), ViewModelAssembly()], container: container)
    }
    
    func registerMockURLSession() {
        container.register(URLSessionProtocol.self) { _ in
            URLSession.mockURLSession()
        }
    }
}


class NetworkAssembly: Assembly {
    func assemble(container: Container) {
        container.register(URLSessionProtocol.self) { _ in
            URLSession.configuredURLSession()
        }
    }
}

class ViewModelAssembly: Assembly {
    func assemble(container: Container) {
//        container.register(AnyMoviesListViewModelProtocol.self) { _ in
//            AnyMoviesListViewModelProtocol(MoviesListViewModel())
//        }
        
//        container.register(AnyMovieDetailViewModelProtocol.self) { resolver in
//            let movieList = resolver.resolve(MoviesListViewModel.MovieItem.self)!
//            return AnyMovieDetailViewModelProtocol(MovieDetailViewModel(movieList: movieList))
//        }
//
//        container.register(AnyImageViewModelProtocol.self) { resolver in
//            let imagePath = resolver.resolve(String.self, name: "imagePath")!
//            let imageSizePath = resolver.resolve(ImagePathProtocol.self, name: "imageSizePath")!
//            let cache = resolver.resolve(ImageCacheProtocol.self)!
//            return AnyImageViewModelProtocol(ImageViewModel(imagePath: imagePath, imageSizePath: imageSizePath, cache: cache))
//        }
    }
}

//let container = Container()
//let assembler = Assembler([NetworkAssembly(), ViewModelAssembly()], container: container)
