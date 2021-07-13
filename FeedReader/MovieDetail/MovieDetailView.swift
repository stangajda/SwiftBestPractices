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
    var body: some View {
        VStack{
            if let movieDetail = service.movieDetail{
                    ImageView(imageUrl: movieDetail.image)
                        .detailMovieImageSize
                    Text(movieDetail.plot)
                        .font(.body)
            } else {
                Spinner(isAnimating: .constant(true), style: .large)
            }
        }.padding(.horizontal)
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
