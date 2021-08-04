//
//  Config.swift
//  FeedReader
//
//  Created by Stan Gajda on 08/07/2021.
//

import SwiftUI

//babcada8d42a5fd4857231c42240debd
//https://api.themoviedb.org/3/movie/550?api_key=babcada8d42a5fd4857231c42240debd

//https://api.themoviedb.org/3/trending/movie/week?api_key=efb6cac7ab6a05e4522f6b4d1ad0fa43
//https://api.themoviedb.org/3/movie/497698?api_key=efb6cac7ab6a05e4522f6b4d1ad0fa43

struct FDRAPIRequest: FDRAPIRequestProtocol {
    static var baseURLString: String { "https://api.themoviedb.org/" }
    static var prefix: String { "3" }
    static var apiKey: String { "babcada8d42a5fd4857231c42240debd" }
}

struct FDRAPIBaseUrl: FDRAPIBaseUrlProtocol {
    static var baseURLString: String { "https://image.tmdb.org/t/p/original" }
}

