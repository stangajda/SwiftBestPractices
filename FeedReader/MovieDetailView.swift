//
//  MovieDetailView.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/07/2021.
//

import SwiftUI

struct MovieDetailView: View {
    @ObservedObject var service = MovieDetailService()
    var movie: Movie
//https://imdb-api.com/en/API/Title/k_66zz106x/tt1375666/Images
    var body: some View {
        ScrollView{
            if let movieDetail = service.movieDetail{
                VStack {
                    ImageView(imageUrl: movieDetail.image)
                        .detailMovieImageSize
                    Text(movieDetail.plot)
                        .font(.body)
                }
            } else {
                ActivityIndicator(isAnimating: .constant(true), style: .large)
            }
        }
        .navigationTitle(movie.fullTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            service.loadMovies(id: movie.id)
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movie: Movie.mock)
    }
}
