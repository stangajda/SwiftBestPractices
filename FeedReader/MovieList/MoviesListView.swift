//
//  MoviesListView.swift
//  FeedReader
//
//  Created by Stan Gajda on 11/07/2021.
//

import SwiftUI

struct MoviesListView: View {
    @ObservedObject var viewModel: MoviesListViewModel
    
    var body: some View {
        NavigationView {
            content
                .navigationBarTitle("Trending Daily")
        }
    }
    
    private var content: AnyView{
        switch viewModel.state {
        case .start:
            return AnyView(startView)
        case .loading:
            return AnyView(loadingView)
        case .loaded(let movies):
            return AnyView(loadedView(movies))
        case .failedLoaded(let error):
            return AnyView(failedView(error))
        }
    }
    
}

private extension MoviesListView {
    var startView: some View {
        Color.clear
            .onAppear {
                viewModel.send(action: .onAppear)
            }
    }
    
    var loadingView: some View {
        ActivityIndicator(isAnimating: .constant(true), style: .large)
    }
    
    func loadedView(_ movies: Array<MoviesListViewModel.MovieItem>) -> some View {
        listMovies(movies)
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(error: error)
    }
//    return List(movies) { movie in
//        NavigationLink(
//            destination: MovieDetailView(viewModel: MovieDetailViewModel(movieID: movie.id)),
//            label: { MovieListItemView(movie: movie) }
//        )
//    }
    
    func listMovies(_ movies: Array<MoviesListViewModel.MovieItem>) -> some View {
        List(movies){ movie in
            NavigationLink(destination: MovieDetailView(viewModel: MovieDetailViewModel(movieList: movie)),
            label: {MovieRowView(movie: movie)}
            )
        }
    }
}


#if DEBUG
//struct MoviesList_Previews: PreviewProvider {
//    static var previews: some View {
////        MoviesListView()
//    }
//}
#endif
