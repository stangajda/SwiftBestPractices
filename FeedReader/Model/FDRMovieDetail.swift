//
//  FDRMovieDetail.swift
//  FeedReader
//
//  Created by Stan Gajda on 21/06/2021.
//

struct FDRMovieDetail: Codable{
    var id: Int
    var title: String
    var overview: String
    var backdrop_path: String
    var vote_average: Double
    var vote_count: Int
    var budget: Int
    var release_date: String
    var genres: Array<FDRMoviesSubItem>
    var spoken_languages: Array<FDRMoviesSubLanguages>
}

struct FDRMoviesSubItem: Codable{
    var id: Int
    var name: String
}

struct FDRMoviesSubLanguages: Codable{
    var name: String
}
