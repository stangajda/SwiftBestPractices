//
//  APICall.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 03/07/2021.
//

import Foundation

protocol APIUrlBuilderProtocol {
    static var baseURL: URL? { get }
    static var prefix: String { get }
    static var apiKey: String { get }
}

extension APIUrlBuilderProtocol {
    static subscript(_ path: PathInterface) -> URL?{
        guard var url = Self.baseURL else {
            return nil
        }
        url.appendPathComponent(Self.prefix)
        url.appendPathComponent(path.stringPath())
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)?
            .addQueryItem(Self.apiKey, forName: "api_key")
        return urlComponents?.url
    }
}

extension URLComponents {
    func addQueryItem(_ apiKey: String, forName name: String) -> URLComponents {
        var copy = self
        copy.queryItems = [URLQueryItem(name: name, value: apiKey)]
        return copy
    }
}
