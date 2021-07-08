//
//  APICall.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 03/07/2021.
//

import Foundation



//static func trending() -> AnyPublisher<PageDTO<MovieDTO>, Error> {
//    let request = URLComponents(url: base.appendingPathComponent("trending/movie/week"), resolvingAgainstBaseURL: true)?
//        .addingApiKey(apiKey)
//        .request
//    return agent.fetchData(request!)
//}

protocol APIRequestInterface {
    static var baseURLString: String { get }
    static var language: String { get }
    static var prefixPath: String { get }
    static var apiKey: String { get }
}

enum APIError: Swift.Error {
    case invalidURL
    case httpCode(HTTPCode)
    case unexpectedResponse
    case imageProcessing([URLRequest])
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case let .httpCode(code): return "Unexpected HTTP code: \(code)"
        case .unexpectedResponse: return "Unexpected response from the server"
        case .imageProcessing: return "Unable to load image"
        }
    }
}

extension APIRequestInterface {
    static func get(path: String) throws -> URLRequest {
        guard var url = URL(string: baseURLString) else {
            throw APIError.invalidURL
        }
        url.appendPathComponent(language)
        url.appendPathComponent(prefixPath)
        url.appendPathComponent(path)
        url.appendPathComponent(apiKey)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200 ..< 300
}
