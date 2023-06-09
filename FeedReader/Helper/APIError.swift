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
}
