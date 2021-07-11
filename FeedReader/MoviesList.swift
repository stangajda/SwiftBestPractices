//
//  MoviesList.swift
//  FeedReader
//
//  Created by Stan Gajda on 11/07/2021.
//

import SwiftUI

struct MoviesList: View {
    @ObservedObject var service: MoviesService = MoviesService()
    
    var body: some View {
        if let movies = service.movies{
            listMovies(movies)
        } else {
            Text("Loading...")
                .onAppear {
                    service.loadMovies()
                }
            ActivityIndicator(isAnimating: .constant(true), style: .large)
        }
    }
    
    func listMovies(_ movies: [Movie]) -> some View {
        List(movies){ movie in
            MovieRow(movie: movie)
        }
    }
}



struct MoviesList_Previews: PreviewProvider {
    static var previews: some View {
        MoviesList()
    }
}
