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
        HStack{
            ImageView(imageUrl: movie.image)
                .frame(width: 64.0, height: 88.0)
            Text(movie.title)
                .font(.title)
        }
        .frame(height: 100)
        
    }
}

struct MovieRow_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            MovieRow(movie: mockMovie)
        }
        .previewLayout(.sizeThatFits)
    }
}
