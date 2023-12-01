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
    var backdrop_path: String
    var vote_average: Double
    var vote_count: Int
    var budget: Int
    var release_date: String
    var genres: [MoviesSubItem]
    var spoken_languages: [MoviesSubLanguages]

    static func == (lhs: MovieDetail, rhs: MovieDetail) -> Bool {
        return lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.overview == rhs.overview &&
            lhs.backdrop_path == rhs.backdrop_path &&
            lhs.vote_average == rhs.vote_average &&
            lhs.vote_count == rhs.vote_count &&
            lhs.budget == rhs.budget &&
            lhs.release_date == rhs.release_date &&
            lhs.genres == rhs.genres &&
            lhs.spoken_languages == rhs.spoken_languages
    }
}

struct MoviesSubItem: Equatable, Codable {
    var id: Int
    var name: String
}

struct MoviesSubLanguages: Equatable, Codable {
    var name: String
}
