//
//  InjectionName.swift
//  FeedReader
//
//  Created by Stan Gajda on 15/07/2023.
//

import Foundation

// MARK:- Injection.Name
extension Injection.Name {
    static let movieListStateStart = Self("MovieListStateStart")
    static let movieListStateLoaded = Self("MovieListStateLoaded")
    static let movieListStateLoading = Self("MovieListStateLoading")
    static let movieListStateFailed = Self("MovieListStateFailed")
    
    static let movieDetailStateStart = Self("MovieDetailStateStart")
    static let movieDetailStateLoaded = Self("MovieDetailStateLoaded")
    static let movieDetailStateLoading = Self("MovieDetailStateLoading")
    static let movieDetailStateFailed = Self("MovieDetailStateFailed")
    
    static let imageStateLoaded = Self("ImageStateLoaded")
    static let imageStateFailed = Self("ImageStateFailed")

    static let movieList = Self("movieList")
    static let movieDetail = Self("movieDetail")
}
