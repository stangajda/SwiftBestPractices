//
//  MoviesListView.swift
//  FeedReader
//
//  Created by Stan Gajda on 11/07/2021.
//

import SwiftUI

struct MoviesListView: View {
    @ObservedObject var service: MoviesService = MoviesService()
    
    var body: some View {
        if let movies = service.movies{
            listMovies(movies.items)
            Text(movies.errorMessage)
                .foregroundColor(Color.red)
        } else {
            Text("Loading...")
                .onAppear {
                    service.loadMovies()
                }
            ActivityIndicator(isAnimating: .constant(true), style: .large)
        }
    }
    
    func listMovies(_ movies: [Movie]) -> some View {
        NavigationView {
            List(movies){ movie in
                NavigationLink(destination: MovieDetailView(movie: movie)){
                    MovieRowView(movie: movie)
                }
            }
        }
    }
}



struct MoviesList_Previews: PreviewProvider {
    static var previews: some View {
        MoviesListView()
    }
}
