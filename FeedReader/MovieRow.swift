//
//  MovieRow.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/07/2021.
//

import SwiftUI

struct MovieRow: View {
    @State var movie: Movie
    
    var body: some View {
        Text(movie.title)
    }
}

struct MovieList_Previews: PreviewProvider {
    static var previews: some View {
        MoviesList()
    }
}
