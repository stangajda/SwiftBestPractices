//
//  MoviesModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 21/06/2021.
//

struct FDRMovies: Hashable, Codable{
    var results: Array<FDRMovie>
    var page: Int
}

struct FDRMovie: Hashable, Codable, Identifiable {
    var id: Int
    var title: String
    var vote_average: Double
    var poster_path: String
}


