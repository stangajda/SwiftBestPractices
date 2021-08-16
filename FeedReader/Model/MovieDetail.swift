//
//  MovieDetail.swift
//  FeedReader
//
//  Created by Stan Gajda on 21/06/2021.
//

struct MovieDetail: Codable{
    var id: Int
    var title: String
    var overview: String
    var backdrop_path: String
    var vote_average: Double
    var vote_count: Int
    var budget: Int
    var release_date: String
    var genres: Array<MoviesSubItem>
    var spoken_languages: Array<MoviesSubLanguages>
}

struct MoviesSubItem: Codable{
    var id: Int
    var name: String
}

struct MoviesSubLanguages: Codable{
    var name: String
}
