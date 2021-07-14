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
        if let movies = viewModel.movies{
            listMovies(movies.items)
            Text(movies.errorMessage)
                .foregroundColor(Color.red)
        } else {
            Spinner(isAnimating: .constant(true), style: .large)
                .onAppear{
                    viewModel.loadMovies()
                }
        }
    }
    
    private var listMovies = {(_ movies: [Movie]) -> AnyView in
        NavigationView {
            List(movies){ movie in
                NavigationLink(destination: MovieDetailView(movie: movie)){
                    MovieRowView(movie: movie)
                }
            }
        }.eraseToAnyView()
    }
    
}



struct MoviesList_Previews: PreviewProvider {
    static var previews: some View {
        MoviesListView()
    }
}
