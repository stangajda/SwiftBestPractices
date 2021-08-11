//
//  Config.swift
//  FeedReader
//
//  Created by Stan Gajda on 08/07/2021.
//

import SwiftUI

struct FDRAPIUrlBuilder: FDRAPIUrlBuilderProtocol {
    static var baseURL: URL? { URL(string: "https://api.themoviedb.org/") }
    static var imageURL: URL? { URL(string: "https://image.tmdb.org/t/p/original") }
    static var prefix: String { "3" }
    static var apiKey: String { "babcada8d42a5fd4857231c42240debd" }
}

extension URLSession{
    static func configuredURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 180
        configuration.httpMaximumConnectionsPerHost = 7
        configuration.urlCache = .shared
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: configuration)
    }
}

