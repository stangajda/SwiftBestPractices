//
//  FDRApp+Injection.swift
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
    register { FDRMoviesListViewModel() as FDRMoviesListViewModel}
    register { FDRMovieListService() as FDRMovieListServiceInterface}
    register { FDRMovieDetailService() as FDRMovieDetailServiceInterface}
    register { FDRImageService() as FDRImageServiceInterface}
    register { FDRService() as FDRServiceInterface}
    register(name:.itemList){ _, args in
        FDRImageViewModel(imagePath: args("imageURL"), cache: args("cache"))
    }
    register(name:.itemDetail){ _, args in
        FDRImageViewModel(imagePath: args("imageURL"), cache: args("cache"))
    }
  }
}

extension Resolver {
    static var preview: Resolver = Resolver(parent: .main)
    static func setupPreviewMode() {
        Resolver.root = .preview
        register(name:.itemList){ FDRMockImageViewModel(.itemList) as FDRImageViewModel}
        register(name:.itemDetail){ FDRMockImageViewModel(.itemDetail) as FDRImageViewModel}
    }
}

extension Resolver.Name {
    static let itemList = Self("ItemList")
    static let itemDetail = Self("ItemDetail")
}
