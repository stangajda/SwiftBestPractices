//
//  APIUrlBuilder.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/08/2021.
//

import Foundation

struct APIUrlBuilder: APIUrlBuilderProtocol {
    static var baseURL: URL { URL(string: Config.API.baseURL) ?? URL(fileURLWithPath: String()) }
    static var prefix: String { Config.API.prefix }
    static var apiKey: String { Config.API.key }
}

protocol PathProtocol {
    func stringPath() -> String
}

struct TrendingPath: PathProtocol {
    func stringPath() -> String {
        Config.API.trendingPath
    }
}

struct MoviePath: PathProtocol {
    fileprivate var id: Int

    init(_ id: Int) {
        self.id = id
    }

    func stringPath() -> String {
        Config.API.moviePath + "/\(String(id))"
    }
}

struct StubEmptyPath: PathProtocol {
    func stringPath() -> String {
        String()
    }
}
