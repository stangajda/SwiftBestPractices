//
//  Config.swift
//  FeedReader
//
//  Created by Stan Gajda on 08/07/2021.
//

import SwiftUI

struct FDRAPIRequest: FDRAPIRequestProtocol {
    static var baseURLString: String { "https://api.themoviedb.org/" }
    static var imageURLString: String { "https://image.tmdb.org/t/p/original" }
    static var prefix: String { "3" }
    static var apiKey: String { "babcada8d42a5fd4857231c42240debd" }
}

