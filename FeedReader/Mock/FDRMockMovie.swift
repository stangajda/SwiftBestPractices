//
//  MockMovie.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/07/2021.
//

extension FDRMovie{
    static let mock = FDRMovie(id: 497698, title: "mock title", poster_path: "/qAZ0pzat24kLdO3o8ejmbLxyOac.jpg", vote_average: 8.2, vote_count: 1511)
}

extension FDRMovieDetail{
    static let mock = FDRMovieDetail(id: 4971212, title: "mock title detail", overview: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", backdrop_path: "/qAZ0pzat24kLdO3o8ejmbLxyOac.jpg", vote_average: 4.2, vote_count: 1821, budget: 1786213, release_date: "2021-05-21", genres: [FDRMoviesSubItem(id: 22, name: "horror"),FDRMoviesSubItem(id: 25, name: "thriller")], spoken_languages: [FDRMoviesSubLanguages(name: "English"),FDRMoviesSubLanguages(name: "Deutch")])
}

extension FDRMoviesListViewModel.MovieItem{
    static let mock = FDRMoviesListViewModel.MovieItem(FDRMovie.mock)
}

extension FDRMovieDetailViewModel.MovieDetailItem{
    static let mock = FDRMoviesListViewModel.MovieItem(FDRMovie.mock)
}
