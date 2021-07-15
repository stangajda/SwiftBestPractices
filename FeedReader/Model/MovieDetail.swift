//
//  MovieDetail.swift
//  FeedReader
//
//  Created by Stan Gajda on 21/06/2021.
//

struct MovieDetail: Hashable, Codable, Identifiable{
    var id: Int
    var title: String
    var overview: String
    var backdrop_path: String
}
