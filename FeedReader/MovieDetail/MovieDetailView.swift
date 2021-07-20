//
//  MovieDetailView.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/07/2021.
//

import SwiftUI

struct MovieDetailView: View {
    @ObservedObject var viewModel: MovieDetailViewModel
    
    var body: some View {
        VStack{
            content
        }
        .navigationTitle(viewModel.movieList.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var content: AnyView{
        switch viewModel.state {
        case .initial:
            return AnyView(initialView)
        case .loading(_):
            return AnyView(loadingView)
        case .loaded(let movDetail):
            return AnyView(loadedView(movDetail))
        case .failedLoaded(let error):
            return AnyView(failedView(error))
        }
    }
    
    
}

private extension MovieDetailView {
    var initialView: some View {
        Color.clear
            .onAppear {
                viewModel.onAppear(id: viewModel.movieList.id)
            }
    }
    
    var loadingView: some View {
        ActivityIndicator(isAnimating: .constant(true), style: .large)
    }
    
    func loadedView(_ movieDetail: MovieDetailViewModel.MovieDetailItem) -> some View {
        movieContent(movieDetail)
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(error: error)
    }
    
    func movieContent(_ movieDetail: MovieDetailViewModel.MovieDetailItem) -> some View {
        VStack{
            ImageView(imageUrl: movieDetail.backdrop_path)
                .detailMovieImageSize
            Text(movieDetail.overview)
                .font(.body)
        }
        .padding()
    }
}

#if DEBUG
struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            //MovieDetailView(movieList: MoviesListViewModel.MovieItem.mock)
        }
    }
}
#endif
