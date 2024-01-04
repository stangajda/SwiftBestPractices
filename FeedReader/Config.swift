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
        static let apiKey = "api_key"
        static let key = "babcada8d42a5fd4857231c42240debd"
        static let trendingPath = "trending/movie/day"
        static let moviePath = "movie"
    }

    struct APIImage {
        static let url = "https://image.tmdb.org/t/p/"
        static let originalPath = "original"
        static let w200Path = "w200"
    }

    struct ImageCache {
        static let totalCostLimit = 50_000_000
    }

    struct QueueMovieList {
        static let label = "com.feedReader.MovieListQueue"
        static let qos = DispatchQoS.userInitiated
    }

    struct QueueMovieDetail {
        static let label = "com.feedReader.MovieDetailQueue"
        static let qos = DispatchQoS.userInteractive
    }

    struct QueueImage {
        static let label = "com.feedReader.ImageQueue"
        static let qos = DispatchQoS.background
    }

    struct Icon {
        static let calendar = "calendar"
        static let starFill = "star.fill"
        static let banknote = "banknote"
        static let speaker = "speaker"
    }

    struct MockMovieList {
        static let movieListResponseResult = "StubMovieListResponseResult.json"
        static let anotherMovieListResponseResult = "StubAnotherMovieListResponseResult.json"

    }

    struct MockMovieDetail {
        static let movieDetailResponseResult = "StubMovieDetailResponseResult.json"
        static let anotherMovieDetailResponseResult = "StubAnotherMovieDetailResponseResult.json"
    }

    struct MockImage {
        static let stubImageMovieMedium = "StubImageMovieMedium"
        static let stubImageMoviedetailsBig = "StubImageMovieDetailsBig"
    }

}

// MARK: - Checking if running tests

extension Config {
    struct Testing {
        static var isRunningTests: Bool {
            return NSClassFromString("XCTest") != nil
        }
    }
}

// MARK: - URLSession
extension URLSession {
    static var `default`: URLSession {
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
    static var mock: URLSession {
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
