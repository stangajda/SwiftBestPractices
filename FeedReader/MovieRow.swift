//
//  MovieRow.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/07/2021.
//

import SwiftUI

struct MovieRow: View {
    @ObservedObject var service: ImageService = ImageService()
    @State var movie: Movie
    
    var body: some View {
        HStack{
            if let image = service.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }else{
                ActivityIndicator(isAnimating: .constant(true), style: .medium)
            }
            Text(movie.title)
                .font(.title)
        }
        .frame(height: 120)
        .onAppear{
            service.loadImage(movie.image)
        }
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
