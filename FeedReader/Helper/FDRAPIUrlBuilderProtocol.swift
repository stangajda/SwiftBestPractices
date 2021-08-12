//
//  APICall.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 03/07/2021.
//

import Foundation

protocol FDRAPIUrlBuilderProtocol {
    static var baseURL: URL? { get }
    static var prefix: String { get }
    static var apiKey: String { get }
}

protocol FDRAPIUrlImageBuilderProtocol {
    static var imageURL: URL? { get }
}

extension FDRAPIUrlBuilderProtocol {
    static subscript(_ path: FDRPath) -> URL?{
        guard var url = Self.baseURL else {
            return nil
        }
        url.appendPathComponent(Self.prefix)
        url.appendPathComponent(path.toString())
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)?
            .addQueryItem(Self.apiKey, forName: "api_key")
        return urlComponents?.url
    }
}

extension FDRAPIUrlImageBuilderProtocol{
    static subscript(_ imageSizePath: FDRImagePath, _ imagePath: String) -> URL?{
        guard var url = Self.imageURL else {
            return nil
        }
        url.appendPathComponent(imageSizePath.toString())
        url.appendPathComponent(imagePath)
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
