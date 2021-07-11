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
            List(movies){ movie in
                Text(movie.title)
            }
        } else {
            Text("Loading...").onAppear {
                service.loadMovies()
            }
        }
    }
}



struct MoviesList_Previews: PreviewProvider {
    static var previews: some View {
        MoviesList()
    }
}
