//
//  MoviesModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 21/06/2021.
//

struct Movies: Hashable, Codable {
    var results: [Movie]
    var page: Int
}

struct Movie: Hashable, Codable, Identifiable {
    var id: Int
    var title: String
    var poster_path: String
    var vote_average: Double
    var vote_count: Int
}


