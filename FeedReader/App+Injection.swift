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
    register { URLSession.shared }
    register { MoviesListViewModel() as MoviesListViewModel}
    register(name:.itemList){ _, args in
        ImageViewModel(imageURL: args("imageURL"), cache: args("cache"))
    }
    register(name:.itemDetail){ _, args in
        ImageViewModel(imageURL: args())
    }
  }
}

extension Resolver {
    static var preview: Resolver!
    static func setupPreviewMode() {
        Resolver.preview = Resolver(parent: .main)
        Resolver.root = .preview
        register(name:.itemList){ MockImageViewModel(.itemList) as ImageViewModel}
        register(name:.itemDetail){ MockImageViewModel(.itemDetail) as ImageViewModel}
    }
}

extension Resolver.Name {
    static let itemList = Self("ItemList")
    static let itemDetail = Self("ItemDetail")
}
