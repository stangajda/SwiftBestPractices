//
//  Config.swift
//  FeedReader
//
//  Created by Stan Gajda on 08/07/2021.
//

import SwiftUI

let API_BASE_URL = "https://api.themoviedb.org/"
let API_PREFIX = "3"
let API_KEY = "babcada8d42a5fd4857231c42240debd"
let API_TRENDING_PATH = "trending/movie/day"
let API_MOVIE_PATH = "movie"
    
let API_IMAGE_URL = "https://image.tmdb.org/t/p/"
let API_IMAGE_ORIGINAL_PATH = "original"
let API_IMAGE_W200_PATH = "w200"
    
let CACHE_TOTAL_COST_LIMIT = 50_000_000


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

