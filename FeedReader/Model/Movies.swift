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
    var posterPath: String
    var voteAverage: Double
    var voteCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
