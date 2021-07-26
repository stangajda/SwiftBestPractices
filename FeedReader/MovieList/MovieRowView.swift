//
//  MovieRowView.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/07/2021.
//

import SwiftUI
import Resolver

struct MovieRowView: View {
    @State var movie: MoviesListViewModel.MovieItem
    @Environment(\.imageCache) var cache: ImageCache
    
    var body: some View {
        HStack{
            ImageView(viewModel: Resolver.resolve(name:.itemList,args:["imageURL": movie.poster_path,"cache": cache as Any]))
                .withRowImageSize()
            Text(movie.title)
        }
        .withRowListStyles()
    }
}

#if DEBUG
struct MovieRow_Previews: PreviewProvider {
    static var previews: some View {
        Resolver.setupPreviewMode()
        return Group{
            MovieRowView(movie: MoviesListViewModel.MovieItem.mock)
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
