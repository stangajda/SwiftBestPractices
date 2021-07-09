//
//  APICall.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 03/07/2021.
//

import Foundation

protocol APIRequestInterface {
    static var baseURLString: String { get }
    static var language: String { get }
    static var prefixPath: String { get }
    static var apiKey: String { get }
}

enum APIError: Swift.Error {
    case invalidURL
    case apiCode(APICode)
    case unknownResponse
    case imageConversion(URLRequest)
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case let .apiCode(code): return "Unexpected API code: \(code)"
        case .unknownResponse: return "Unknown response from the server"
        case .imageConversion: return "Unable to load image"
        }
    }
}

extension APIRequestInterface {
    static subscript(_ path: String) -> URLRequest{
        guard var url = URL(string: Self.baseURLString) else {
            fatalError("invalid URL")
        }
        url.appendPathComponent(Self.language)
        url.appendPathComponent(Self.prefixPath)
        url.appendPathComponent(path)
        url.appendPathComponent(Self.apiKey)
        return URLRequest(url: url)
    }
}

typealias APICode = Int
typealias APICodes = Range<APICode>

extension APICodes {
    static let success = 200 ..< 300
}
