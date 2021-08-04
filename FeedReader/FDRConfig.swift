//
//  Config.swift
//  FeedReader
//
//  Created by Stan Gajda on 08/07/2021.
//

import SwiftUI

struct FDRAPIRequest: FDRAPIRequestProtocol {
    static var baseURL: URL? { URL(string: "https://api.themoviedb.org/") }
    static var imageURL: URL? { URL(string: "https://image.tmdb.org/t/p/original") }
    static var prefix: String { "3" }
    static var apiKey: String { "babcada8d42a5fd4857231c42240debd" }
}

