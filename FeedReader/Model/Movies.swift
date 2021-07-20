//
//  MoviesModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 21/06/2021.
//

struct Movies: Codable{
    var results: Array<Movie>
    var page: Int
}

struct Movie: Codable{
    var id: Int
    var title: String
    var vote_average: Double
    var poster_path: String
}


