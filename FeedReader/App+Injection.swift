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
      
    register { 
      URLSession.configuredURLSession() 
    }
      
    register { 
      MoviesListViewModelWrapper(MoviesListViewModel()) as MoviesListViewModelWrapper
    }
      
    register { (_, args) in
        MovieDetailViewModelWrapper(MovieDetailViewModel(movieList:args(VIEW_MOVIE_LIST))) as MovieDetailViewModelWrapper
    }

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
        
        register(name:.movieListStateLoaded){ 
          MoviesListViewModelWrapper(MockMoviesListViewModelLoaded()) as MoviesListViewModelWrapper
        }
        
        register(name:.movieListStateLoading){ 
          MoviesListViewModelWrapper(MockMoviesListViewModelLoading()) as MoviesListViewModelWrapper
        }
        
        register(name:.movieListStateFailed){ 
          MoviesListViewModelWrapper(MockMoviesListViewModelFailed()) as MoviesListViewModelWrapper
        }
        
        register(name:.movieDetailStateLoaded){
          MovieDetailViewModelWrapper(MockMovieDetailViewModelLoaded(movieList: MoviesListViewModel.MovieItem.mock)) as MovieDetailViewModelWrapper
        }

        register(name:.movieDetailStateLoading){
          MovieDetailViewModelWrapper(MockMovieDetailViewModelLoading(movieList: MoviesListViewModel.MovieItem.mock)) as MovieDetailViewModelWrapper
        }

        register(name:.movieDetailStateFailed){
          MovieDetailViewModelWrapper(MockMovieDetailViewModelFailed(movieList: MoviesListViewModel.MovieItem.mock)) as MovieDetailViewModelWrapper
        }
        //register { MoviesListViewModelWrapper(MockMoviesListViewModelLoaded()) as MoviesListViewModelWrapper}
//        register(name:.itemList){ MockImageViewModel(.itemList) as ImageViewModel}
//        register(name:.itemDetail){ MockImageViewModel(.itemDetail) as ImageViewModel}
    }
}

extension Resolver.Name {
    
    static let movieListStateLoaded = Self("MovieListStateLoaded")
    static let movieListStateLoading = Self("MovieListStateLoading")
    static let movieListStateFailed = Self("MovieListStateFailed")
    
    static let movieDetailStateLoaded = Self("MovieDetailStateLoaded")
    static let movieDetailStateLoading = Self("MovieDetailStateLoading")
    static let movieDetailStateFailed = Self("MovieDetailStateFailed")

    static let itemList = Self("ItemList")
    static let itemDetail = Self("ItemDetail")
}
