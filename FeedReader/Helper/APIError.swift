//
//  APIError.swift
//  FeedReader
//
//  Created by Stan Gajda on 04/08/2021.
//

import Foundation

enum APIError: Swift.Error, Equatable {
    case invalidURL
    case apiCode(APICode)
    case unknownResponse
    case imageConversion(URLRequest)
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}

extension APIError: LocalizedError {
    init(_ error: Swift.Error) {
        self = error as? APIError ?? .unknownResponse
    }
    
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
