//
//  MoviesList.swift
//  FeedReader
//
//  Created by Stan Gajda on 11/07/2021.
//

import SwiftUI

struct MoviesList: View {
    @State var movies: Array<MovieDetail>?
    
    var body: some View {
        if let movies = movies{
            List(movies){ movie in
                Text(movie.title)
            }
        } else {
            Text("Loading...")
        }
    }
}

//struct MoviesList_Previews: PreviewProvider {
//    static var previews: some View {
//        MoviesList()
//    }
//}
