//
//  MovieDetailView.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/07/2021.
//

import SwiftUI

struct MovieDetailView: View {
    @ObservedObject var viewModel = MovieDetailViewModel()
    var movie: Movie
    var body: some View {
        VStack{
            switch viewModel.state{
            case .idle:
                Color.clear.eraseToAnyView()
            case .loading(_):
                Spinner(isAnimating: .constant(true), style: .large)
            case .loaded(let movDetail):
                movieContent(movDetail)
            case .failedLoaded(let error): 
                Text(verbatim: error.localizedDescription)
            }
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            viewModel.loadMovies(id: movie.id)
        }
    }
    
    var movieContent = { (movieDetail: MovieDetail) -> AnyView in
        VStack{
            ImageView(imageUrl: movieDetail.backdrop_path)
                .detailMovieImageSize
            Text(movieDetail.overview)
                .font(.body)
        }
        .padding()
        .eraseToAnyView()
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movie: Movie.mock)
    }
}
