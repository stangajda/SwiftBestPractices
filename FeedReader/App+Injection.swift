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
      registerURLSession()
      registerViewModels()
      registerServices()
  }
    
  static func registerURLSession() {
    register {
        URLSession.configuredURLSession()
    }
  }
    
  static func registerViewModels() {
    register {
        AnyMoviesListViewModelProtocol(MoviesListViewModel()) as AnyMoviesListViewModelProtocol
    }
      
    register { (_, args) in
        AnyMovieDetailViewModelProtocol(MovieDetailViewModel(movieList: args(DI_MOVIE_LIST))) as AnyMovieDetailViewModelProtocol
    }
    
    register { (_, args) in
        AnyImageViewModelProtocol(ImageViewModel(imagePath: args(DI_IMAGE_PATH), imageSizePath: args(DI_IMAGE_SIZE_PATH), cache: args(DI_IMAGE_CACHE))) as AnyImageViewModelProtocol
    }

  }
    
  static func registerServices() {
    register {
        MovieListService() as MovieListServiceProtocol
    }
      
    register {
        MovieDetailService() as MovieDetailServiceProtocol
    }
      
    register {
        ImageService() as ImageServiceProtocol
    }
      
    register {
        Service() as ServiceProtocol
    }
  }
}

extension Resolver {
    static var preview: Resolver = Resolver(child: .main)
    static func setupPreviewMode() {
        Resolver.root = .preview
        
        registerMoviesListViewModel()
        registerMovieDetailViewModel()
        registerImageViewModel()
    }

    static var previewMovieDetail: Resolver = Resolver(child: .main)
    static func setupPreviewModeMovieDetail() {
        Resolver.root = .previewMovieDetail
        
        registerMovieDetailViewModel()
        registerImageViewModelItemDetail()
    }
    
    private static func registerMoviesListViewModel() {
        register(name:.movieListStateLoaded){
            AnyMoviesListViewModelProtocol(MockMoviesListViewModel(.loaded)) as AnyMoviesListViewModelProtocol
        }
        
        register(name:.movieListStateLoading){
            AnyMoviesListViewModelProtocol(MockMoviesListViewModel(.loading)) as AnyMoviesListViewModelProtocol
        }
        
        register(name:.movieListStateFailed){
            AnyMoviesListViewModelProtocol(MockMoviesListViewModel(.failedLoaded)) as AnyMoviesListViewModelProtocol
        }
    }
    
    private static func registerMovieDetailViewModel() {
        register(name:.movieDetailStateLoaded){
            AnyMovieDetailViewModelProtocol(MockMovieDetailViewModel(.loaded, MoviesListViewModel.MovieItem.mock)) as AnyMovieDetailViewModelProtocol
        }

        register(name:.movieDetailStateLoading){
            AnyMovieDetailViewModelProtocol(MockMovieDetailViewModel(.loading, MoviesListViewModel.MovieItem.mock)) as AnyMovieDetailViewModelProtocol
        }

        register(name:.movieDetailStateFailed){
            AnyMovieDetailViewModelProtocol(MockMovieDetailViewModel(.failedLoaded, MoviesListViewModel.MovieItem.mock)) as AnyMovieDetailViewModelProtocol
        }
    }

    private static func registerImageViewModel() {
        register {
            AnyImageViewModelProtocol(MockImageViewModelLoaded()) as AnyImageViewModelProtocol
        }
    }

    private static func registerImageViewModelItemDetail() {
        register {
            AnyImageViewModelProtocol(MockImageViewModelLoaded(.itemDetail)) as AnyImageViewModelProtocol
        }
    }
}

extension Resolver.Name {
    
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
