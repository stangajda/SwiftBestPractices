//
//  APICall.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 03/07/2021.
//

import Foundation

protocol FDRAPIUrlBuilderProtocol {
    static var baseURL: URL? { get }
    static var imageURL: URL? { get }
    static var prefix: String { get }
    static var apiKey: String { get }
}

extension FDRAPIUrlBuilderProtocol {
    static func getUrl(_ path: Path) -> URL?{
        guard var url = Self.baseURL else {
            return nil
        }
        url.appendPathComponent(Self.prefix)
        url.appendPathComponent(path.toString())
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)?
            .addQueryItem(Self.apiKey, forName: "api_key")
        return urlComponents?.url
    }
    
    static func getImageURL(_ path: String) -> URL?{
        guard var url = Self.imageURL else {
            return nil
        }
        url.appendPathComponent(path)
        return url
    }
}

extension URLComponents {
    func addQueryItem(_ apiKey: String, forName name: String) -> URLComponents {
        var copy = self
        copy.queryItems = [URLQueryItem(name: name, value: apiKey)]
        return copy
    }
}
