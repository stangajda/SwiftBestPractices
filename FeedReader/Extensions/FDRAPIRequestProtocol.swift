//
//  APICall.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 03/07/2021.
//

import Foundation

protocol FDRAPIRequestProtocol {
    static var baseURLString: String { get }
    static var prefix: String { get }
    static var apiKey: String { get }
}

enum FDRAPIError: Swift.Error {
    case invalidURL
    case apiCode(APICode)
    case unknownResponse
    case imageConversion(URLRequest)
}

extension FDRAPIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case let .apiCode(code):
            return "Unexpected API code: error \(code)."
        case .unknownResponse:
            return "Unknown response from the server"
        case .imageConversion:
            return "Unable to load image"
        }
    }
}

//https://api.themoviedb.org/3/trending/movie/week?api_key=efb6cac7ab6a05e4522f6b4d1ad0fa43

extension FDRAPIRequestProtocol {
    static subscript(_ path: String) -> URLRequest{
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
}

extension URLComponents {
    func addQueryItem(_ apiKey: String, forName name: String) -> URLComponents {
        var copy = self
        copy.queryItems = [URLQueryItem(name: name, value: apiKey)]
        return copy
    }
}

typealias APICode = Int
typealias APICodes = Range<APICode>

extension APICodes {
    static let success = 200 ..< 300
}
