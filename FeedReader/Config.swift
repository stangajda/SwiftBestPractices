//
//  Config.swift
//  FeedReader
//
//  Created by Stan Gajda on 08/07/2021.
//

import SwiftUI

//babcada8d42a5fd4857231c42240debd
//https://api.themoviedb.org/3/movie/550?api_key=babcada8d42a5fd4857231c42240debd

struct APIRequest: APIRequestInterface {
    static var baseURLString: String { "https://imdb-api.com/" }
    static var language: String { "en" }
    static var prefixPath: String { "API" }
    static var apiKey: String { "k_66zz106x" }
}

extension View {
    var rowSize: some View {
        frame(maxWidth: .infinity, maxHeight: 96, alignment: .leading)
    }
    
    var rowImageSize: some View{
        frame(width: 64.0, height: 88.0)
    }
    
    var detailMovieImageSize: some View{
        frame(width: 400.0, height: 340.0)
    }
}
