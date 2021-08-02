//
//  FDRMovieRowView.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/07/2021.
//

import SwiftUI
import Resolver

struct FDRMovieRowView: View {
    @State var movie: FDRMoviesListViewModel.MovieItem
    @Environment(\.imageCache) var cache: FDRImageCache
    
    var body: some View {
        HStack{
            FDRImageView(viewModel: Resolver.resolve(name:.itemList,args:["imageURL": movie.poster_path,"cache": cache as Any]))
                .withRowListImageSize()
            VStack(alignment:.leading){
                Text(movie.title)
                    .font(.title2)
                    .minimumScaleFactor(0.5)
                FDRStarsVotedView(rating: 3.7, voteCount: 212)
                    .frame(maxWidth: 120, maxHeight: 20, alignment: .leading)
                    .font(.caption)
            }
        }
        .withRowListStyles()
    }
}

#if DEBUG
struct MovieRow_Previews: PreviewProvider {
    static var previews: some View {
        Resolver.setupPreviewMode()
        return Group{
            FDRMovieRowView(movie: FDRMoviesListViewModel.MovieItem.mock)
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
