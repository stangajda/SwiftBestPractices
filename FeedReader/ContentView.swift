//
//  ContentView.swift
//  FeedReader
//
//  Created by Stan Gajda on 16/06/2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject var service = MoviesService()
    var body: some View {
        MoviesList(movies: service.movies)
            .onAppear(perform: service.loadMovies)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
