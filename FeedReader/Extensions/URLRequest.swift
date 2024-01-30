//
//  URLRequest.swift
//  FeedReader
//
//  Created by Stan Gajda on 30/01/2024.
//

import Foundation

extension URLRequest {
    func get() -> URLRequest {
        var copy = self
        copy.httpMethod = "GET"
        return copy
    }
}
