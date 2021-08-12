//
//  Config.swift
//  FeedReader
//
//  Created by Stan Gajda on 08/07/2021.
//

import SwiftUI

struct FDRAPIUrlBuilder: FDRAPIUrlBuilderProtocol {
    static var baseURL: URL? { URL(string: "https://api.themoviedb.org/") }
    static var prefix: String { "3" }
    static var apiKey: String { "babcada8d42a5fd4857231c42240debd" }
}

protocol FDRPathProtocol {
    func stringPath() -> String
}

struct FDRTrendingPath: FDRPathProtocol{
    func stringPath() -> String {
        "trending/movie/day"
    }
}

struct FDRMoviePath: FDRPathProtocol{
    var id: Int
    
    init(_ id: Int){
        self.id = id
    }
    
    func stringPath() -> String {
        "movie/\(String(id))"
    }
}

struct FDRAPIUrlImageBuilder: FDRAPIUrlImageBuilderProtocol{
    static var imageURL: URL? { URL(string: "https://image.tmdb.org/t/p/") }
}

protocol FDRImagePathProtocol {
    func stringPath() -> String
}

struct FDROriginalPath: FDRImagePathProtocol{
    func stringPath() -> String{
        "original"
    }
}

struct FDRW200Path: FDRImagePathProtocol {
    func stringPath() -> String {
        "w200"
    }
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

