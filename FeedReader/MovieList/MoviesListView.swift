//
//  MoviesListView.swift
//  FeedReader
//
//  Created by Stan Gajda on 11/07/2021.
//

import SwiftUI

struct MoviesListView: View {
    @ObservedObject var viewModel: MoviesListViewModel = MoviesListViewModel()
    
    var body: some View {
        NavigationView {
            content
                .navigationBarTitle("Trending Daily")
        }
    }
    
    private var content: AnyView{
        switch viewModel.state {
        case .initial:
            return AnyView(initialView)
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
    var initialView: some View {
        Color.clear
            .onAppear {
                viewModel.onAppear()
            }
    }
    
    var loadingView: some View {
        ActivityIndicator(isAnimating: .constant(true), style: .large)
    }
    
    func loadedView(_ movies: [Movie]) -> some View {
        listMovies(movies)
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(error: error)
    }
    
    func listMovies(_ movies: [Movie]) -> some View {
        List(movies){ movie in
            NavigationLink(destination: MovieDetailView(movie: movie)){
                MovieRowView(movie: movie)
            }
        }
    }
}


#if DEBUG
struct MoviesList_Previews: PreviewProvider {
    static var previews: some View {
        MoviesListView()
    }
}
#endif
