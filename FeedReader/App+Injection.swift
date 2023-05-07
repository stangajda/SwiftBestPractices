//
//  App+Injection.swift
//  FeedReader
//
//  Created by Stan Gajda on 23/07/2021.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {
  public static func registerAllServices() {
    defaultScope = .graph
    register { URLSession.configuredURLSession() }
    register { MoviesListViewModelWrapper(MoviesListViewModel()) as MoviesListViewModelWrapper}
    register { MovieListService() as MovieListServiceProtocol}
    register { MovieDetailService() as MovieDetailServiceProtocol}
    register { ImageService() as ImageServiceProtocol}
    register { Service() as ServiceProtocol}
//    register(name:.itemList){ _, args in
//        ImageViewModel(imagePath: args("imageURL"), imageSizePath: args("imageSizePath"), cache: args("cache"))
//    }
//    register(name:.itemDetail){ _, args in
//        ImageViewModel(imagePath: args("imageURL"), imageSizePath: args("imageSizePath"), cache: args("cache"))
//    }
  }
}

extension Resolver {
    static var preview: Resolver = Resolver(child: .main)
    static func setupPreviewMode() {
        Resolver.root = .preview
        register(name:.moviesListLoaded){ MoviesListViewModelWrapper(MockMoviesListViewModelLoaded()) as MoviesListViewModelWrapper}
        register(name:.moviesListLoading){ MoviesListViewModelWrapper(MockMoviesListViewModelLoading()) as MoviesListViewModelWrapper}
        register(name:.moviesListFailed){ MoviesListViewModelWrapper(MockMoviesListViewModelFailed()) as MoviesListViewModelWrapper}
        //register { MoviesListViewModelWrapper(MockMoviesListViewModelLoaded()) as MoviesListViewModelWrapper}
//        register(name:.itemList){ MockImageViewModel(.itemList) as ImageViewModel}
//        register(name:.itemDetail){ MockImageViewModel(.itemDetail) as ImageViewModel}
    }
}

extension Resolver.Name {
    static let moviesListLoaded = Self("MoviesListLoaded")
    static let moviesListLoading = Self("MoviesListLoading")
    static let moviesListFailed = Self("MoviesListFailed")

    static let movieDetailLoaded = Self("MovieDetailLoaded")
    static let movieDetailLoading = Self("MovieDetailLoading")
    static let movieDetailFailed = Self("MovieDetailFailed")

    static let itemList = Self("ItemList")
    static let itemDetail = Self("ItemDetail")
}
