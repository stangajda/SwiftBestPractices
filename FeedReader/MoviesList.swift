//
//  MoviesList.swift
//  FeedReader
//
//  Created by Stan Gajda on 11/07/2021.
//

import SwiftUI

struct MoviesList: View {
    let moviesService = MoviesService()
    var body: some View {
        List(moviesService.movies!){ movie in
            Text(movie.title)
        }
    }
}

struct MoviesList_Previews: PreviewProvider {
    static var previews: some View {
        MoviesList()
    }
}
