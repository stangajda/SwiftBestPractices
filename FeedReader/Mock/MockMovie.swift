//
//  MockMovie.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/07/2021.
//

extension Movie{
    static let mock = Movie(id: 497698, title: "title", vote_average: 8.2, poster_path: "/qAZ0pzat24kLdO3o8ejmbLxyOac.jpg")
}

extension MoviesListViewModel.MovieItem{
    static let mock = MoviesListViewModel.MovieItem(Movie.mock)
}
