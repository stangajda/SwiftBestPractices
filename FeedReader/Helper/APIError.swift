//
//  APIError.swift
//  FeedReader
//
//  Created by Stan Gajda on 04/08/2021.
//

import Foundation

enum APIError: Swift.Error {
    case invalidURL
    case apiCode(APICode)
    case unknownResponse
    case imageConversion(URLRequest)
}

extension APIError: LocalizedError {
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
