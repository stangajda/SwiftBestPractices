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
    register { URLSession.shared }
    register { FDRMoviesListViewModel() as FDRMoviesListViewModel}
    register(name:.itemList){ _, args in
        FDRImageViewModel(imageURL: args("imageURL"), cache: args("cache"))
    }
    register(name:.itemDetail){ _, args in
        FDRImageViewModel(imageURL: args("imageURL"), cache: args("cache"))
    }
  }
}

extension Resolver {
    static var preview: Resolver!
    static func setupPreviewMode() {
        Resolver.preview = Resolver(parent: .main)
        Resolver.root = .preview
        register(name:.itemList){ FDRMockImageViewModel(.itemList) as FDRImageViewModel}
        register(name:.itemDetail){ FDRMockImageViewModel(.itemDetail) as FDRImageViewModel}
    }
}

extension Resolver.Name {
    static let itemList = Self("ItemList")
    static let itemDetail = Self("ItemDetail")
}