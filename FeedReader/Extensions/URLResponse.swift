//
//  URLResponse.swift
//  FeedReader
//
//  Created by Stan Gajda on 30/01/2024.
//

import Foundation

extension URLResponse {
    func mapError(_ data: Data) throws -> Data {
        let apiCodes: APICodes = .success
        guard let code = (self as? HTTPURLResponse)?.statusCode else {
            throw APIError.unknownResponse
        }
        guard apiCodes.contains(code) else {
            throw APIError.apiCode(code)
        }
        return data
    }
}
