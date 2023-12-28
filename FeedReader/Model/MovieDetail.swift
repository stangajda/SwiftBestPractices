//
//  MovieDetail.swift
//  FeedReader
//
//  Created by Stan Gajda on 21/06/2021.
//

struct MovieDetail: Equatable, Codable {
    var id: Int
    var title: String
    var overview: String
    var backdropPath: String
    var voteAverage: Double
    var voteCount: Int
    var budget: Int
    var releaseDate: String
    var genres: [MoviesSubItem]
    var spokenLanguages: [MoviesSubLanguages]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case budget
        case releaseDate = "release_date"
        case genres
        case spokenLanguages = "spoken_languages"
    }

    static func == (lhs: MovieDetail, rhs: MovieDetail) -> Bool {
        return lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.overview == rhs.overview &&
            lhs.backdropPath == rhs.backdropPath &&
            lhs.voteAverage == rhs.voteAverage &&
            lhs.voteCount == rhs.voteCount &&
            lhs.budget == rhs.budget &&
            lhs.releaseDate == rhs.releaseDate &&
            lhs.genres == rhs.genres &&
            lhs.spokenLanguages == rhs.spokenLanguages
    }
}

struct MoviesSubItem: Equatable, Codable {
    var id: Int
    var name: String
}

struct MoviesSubLanguages: Equatable, Codable {
    var name: String
}
