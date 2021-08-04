//
//  APICall.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 03/07/2021.
//

import Foundation

protocol FDRAPIRequestProtocol {
    static var baseURLString: String { get }
    static var imageURLString: String { get }
    static var prefix: String { get }
    static var apiKey: String { get }
}

extension FDRAPIRequestProtocol {
    static func getRequest(_ path: String) -> URLRequest{
        guard var url = URL(string: Self.baseURLString) else {
            fatalError("invalid URL")
        }
        url.appendPathComponent(Self.prefix)
        url.appendPathComponent(path)
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)?
            .addQueryItem(Self.apiKey, forName: "api_key")
        guard let url = urlComponents?.url else {
            fatalError("invalid URL")
        }
        return URLRequest(url: url).get()
    }
    
    static func imageUrl(_ path: String) -> URL{
        guard var url = URL(string: Self.imageURLString) else {
            fatalError("invalid URL")
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
