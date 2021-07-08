//
//  Config.swift
//  FeedReader
//
//  Created by Stan Gajda on 08/07/2021.
//

import Foundation

struct APIRequest: APIRequestInterface {
    static var baseURLString: String { "https://imdb-api.com/" }
    static var language: String { "en" }
    static var prefixPath: String { "API" }
    static var apiKey: String { "k_66zz106x" }
}
