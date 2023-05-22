//
//  Config.swift
//  FeedReader
//
//  Created by Stan Gajda on 08/07/2021.
//

import SwiftUI

let MOVIELIST_TITLE = "Trending Daily"

// MARK:- API
let API_BASE_URL = "https://api.themoviedb.org/"
let API_PREFIX = "3"
let API_KEY = "babcada8d42a5fd4857231c42240debd"
let API_TRENDING_PATH = "trending/movie/day"
let API_MOVIE_PATH = "movie"
    
let API_IMAGE_URL = "https://image.tmdb.org/t/p/"
let API_IMAGE_ORIGINAL_PATH = "original"
let API_IMAGE_W200_PATH = "w200"

let DI_MOVIE_LIST = "movieList"
let DI_IMAGE_PATH = "imagePath"
let DI_IMAGE_SIZE_PATH = "imageSizePath"
let DI_IMAGE_CACHE = "imageCache"



let VIEW_MOVIE_LIST_LOADED = "Movies list loaded"
let VIEW_MOVIE_LIST_LOADING = "Movies list loading"
let VIEW_MOVIE_LIST_FAILED = "Movies list failed"

let VIEW_MOVIE_DETAIL_LOADED = "Movie detail loaded"
let VIEW_MOVIE_DETAIL_LOADING = "Movie detail loading"
let VIEW_MOVIE_DETAIL_FAILED = "Movie detail failed"


// MARK:- Cache
let CACHE_TOTAL_COST_LIMIT = 50_000_000

// MARK:- URLSession
extension URLSession{
    static func configuredURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        let urlCache = URLCache(memoryCapacity: 20_000_000, diskCapacity: 50_000_000)
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 180
        configuration.httpMaximumConnectionsPerHost = 7
        configuration.urlCache = urlCache
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return URLSession(configuration: configuration)
    }
    static func mockURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        configuration.timeoutIntervalForRequest = 1
        configuration.timeoutIntervalForResource = 1
        configuration.waitsForConnectivity = false
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        configuration.httpCookieStorage = nil
        configuration.urlCredentialStorage = nil
        configuration.httpCookieAcceptPolicy = .never
        configuration.httpShouldSetCookies = false
        configuration.httpMaximumConnectionsPerHost = 1
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        configuration.networkServiceType = .responsiveData
        configuration.allowsCellularAccess = true
        configuration.isDiscretionary = false
        configuration.shouldUseExtendedBackgroundIdleMode = false
        configuration.urlCredentialStorage = nil
        return URLSession(configuration: configuration)
    }
}

