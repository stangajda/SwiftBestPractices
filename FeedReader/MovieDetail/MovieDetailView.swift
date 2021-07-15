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
            content
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            viewModel.loadMovies(id: movie.id)
        }
    }
    
    private var content: AnyView{
        switch viewModel.state {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading(_):
            return Spinner(isAnimating: .constant(true), style: .large).eraseToAnyView()
        case .loaded(let movDetail):
            return movieContent(movDetail)
        case .failedLoaded(let error):
            return Text(error.localizedDescription)
                .eraseToAnyView()
        }
    }
    
    internal var movieContent = { (movieDetail: MovieDetail) -> AnyView in
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
        Group {
            MovieDetailView(movie: Movie.mock)
        }
    }
}
