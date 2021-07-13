//
//  MoviesModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 21/06/2021.
//

struct Movies: Hashable, Codable{
    var items: Array<Movie>
    var errorMessage: String
}

struct Movie: Hashable, Codable, Identifiable {
    var id: String
    var rank: String
    var title: String
    var fullTitle: String
    var year: String
    var image: String
    var crew: String
    var imDbRating: String
    var imDbRatingCount: String
}


