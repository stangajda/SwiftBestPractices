//
//  Config.swift
//  FeedReader
//
//  Created by Stan Gajda on 08/07/2021.
//

import SwiftUI

struct Config {
    struct MovieList {
        static let title = "Trending Daily"
    }
    
    struct API {
        static let baseURL = "https://api.themoviedb.org/"
        static let prefix = "3"
        static let key = "babcada8d42a5fd4857231c42240debd"
        static let trendingPath = "trending/movie/day"
        static let moviePath = "movie"
        
        struct Image {
            static let url = "https://image.tmdb.org/t/p/"
            static let originalPath = "original"
            static let w200Path = "w200"
        }
    }
    
    struct DI {
        static let movieList = "movieList"
        static let imagePath = "imagePath"
        static let imageSizePath = "imageSizePath"
        static let imageCache = "imageCache"
    }
    
    struct View {
        struct MovieList {
            static let loaded = "Movies list loaded"
            static let loading = "Movies list loading"
            static let failed = "Movies list failed"
        }
        
        struct MovieDetail {
            static let loaded = "Movie detail loaded"
            static let loading = "Movie detail loading"
            static let failed = "Movie detail failed"
        }
    }
    
    struct Cache {
        static let totalCostLimit = 50_000_000
    }
    
    struct Queue {
        struct MovieList {
            static let label = "com.feedReader.MovieListQueue"
            static let qos = DispatchQoS.userInitiated
        }
        
        struct MovieDetail {
            static let label = "com.feedReader.MovieDetailQueue"
            static let qos = DispatchQoS.userInteractive
        }
        
        struct Image {
            static let label = "com.feedReader.ImageQueue"
            static let qos = DispatchQoS.background
        }
    }
}

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
}

extension URLSession {
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

