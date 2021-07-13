//
//  MovieDetail.swift
//  FeedReader
//
//  Created by Stan Gajda on 21/06/2021.
//

struct MovieDetail: Hashable, Codable{
    var id: String
    var fullTitle: String
    var plot: String
    var runtimeStr: String
    var awards: String
    private var images: MovieItems
    var image: String {
        images.items[0].image
    }
    var errorMessage: String
}

fileprivate struct MovieItems: Hashable, Codable{
    var items: Array<MovieImage>
}

fileprivate struct MovieImage: Hashable, Codable{
    var title: String
    var image: String
}
