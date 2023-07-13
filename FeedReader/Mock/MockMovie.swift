//
//  MockMovie.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/07/2021.
//

import Foundation

fileprivate extension Movie{
    static let mock = Movie(id: 497698, title: "mock title", poster_path: "/qAZ0pzat24kLdO3o8ejmbLxyOac.jpg", vote_average: 8.2, vote_count: 1511)
}

extension MovieDetail{
    static let mock = MovieDetail(id: 4971212, title: "mock title detail", overview: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", backdrop_path: "/qAZ0pzat24kLdO3o8ejmbLxyOac.jpg", vote_average: 4.2, vote_count: 1821, budget: 1786213, release_date: "2021-05-21", genres: [MoviesSubItem(id: 22, name: "horror"),MoviesSubItem(id: 25, name: "thriller")], spoken_languages: [MoviesSubLanguages(name: "English"),MoviesSubLanguages(name: "Deutch")])
}

extension MoviesListViewModel.MovieItem{
    static let mock = MoviesListViewModel.MovieItem(Movie.mock)
}

extension MovieDetailViewModel.MovieDetailItem{
    static let mock = MovieDetailViewModel.MovieDetailItem(MovieDetail.mock)
}
