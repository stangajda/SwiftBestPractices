//
//  MovieRowView.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/07/2021.
//

import SwiftUI

struct MovieRowView: View {
    @State var movie: Movie
    
    var body: some View {
        HStack{
            ImageView(imageUrl: movie.image)
                .rowImageSize
            Text(movie.title)
                .font(.title)
        }
        .padding()
        .rowSize
    }
}

struct MovieRow_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            MovieRowView(movie: Movie.mock)
        }
        .previewLayout(.sizeThatFits)
    }
}
