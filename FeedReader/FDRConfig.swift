//
//  Config.swift
//  FeedReader
//
//  Created by Stan Gajda on 08/07/2021.
//

import SwiftUI

struct FDRConfig{
    static let BASE_URL = "https://api.themoviedb.org/"
    static let PREFIX = "3"
    static let API_KEY = "babcada8d42a5fd4857231c42240debd"
    static let TRENDING_PATH = "trending/movie/day"
    static let MOVIE_PATH = "movie/"
    
    static let IMAGE_URL = "https://image.tmdb.org/t/p/"
    static let ORIGINAL_PATH = "original"
    static let W200_PATH = "w200"
    
    static let CACHE_TOTAL_COST_LIMIT = 50_000_000
}

extension URLSession{
    static func configuredURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 180
        configuration.httpMaximumConnectionsPerHost = 7
        configuration.urlCache = .shared
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return URLSession(configuration: configuration)
    }
}

