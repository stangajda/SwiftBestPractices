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
            Image("StubImageMovieSmall")
                .resizable()
                .aspectRatio(contentMode: .fit)

                
            Text(movie.title)
                .font(.title)
        }
        .frame(height: 120)
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
