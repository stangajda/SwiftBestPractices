//
//  APICall.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 03/07/2021.
//

import Foundation

protocol APIUrlBuilderProtocol {
    static var baseURL: URL { get }
    static var prefix: String { get }
    static var apiKey: String { get }
}

extension APIUrlBuilderProtocol {
    static subscript(_ path: PathProtocol) -> URL {
        var url = Self.baseURL
        url.appendPathComponent(Self.prefix)
        url.appendPathComponent(path.stringPath())
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)?
            .addQueryItem(Self.apiKey, forName: Config.API.apiKey)
        return urlComponents?.url ?? url
    }
}

extension URLComponents {
    func addQueryItem(_ apiKey: String, forName name: String) -> URLComponents {
        var copy = self
        copy.queryItems = [URLQueryItem(name: name, value: apiKey)]
        return copy
    }
}
