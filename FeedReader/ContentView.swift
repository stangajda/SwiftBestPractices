//
//  ContentView.swift
//  FeedReader
//
//  Created by Stan Gajda on 16/06/2021.
//

import SwiftUI

struct ContentView: View {
    let moviesService = MoviesService()
    var body: some View {
        MoviesList()
            .onAppear(perform: moviesService.loadMovies)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
