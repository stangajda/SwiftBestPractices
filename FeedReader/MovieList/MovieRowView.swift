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
    @Environment(\.imageCache) var cache: ImageCacheProtocol
    
    var body: some View {
        HStack{
            // let cache = cache as Any
            // let imageSizePath = OriginalPath() as ImagePathProtocol
            // let imageURL = movieDetail.backdrop_path
            // let args = ["imageURL": imageURL,
            //                 "imageSizePath": imageSizePath,
            //                 "cache": cache as Any]
            // ImageView(viewModel: Resolver.resolve(name:.itemDetail, args:args))
            //         .withImageStyle()

            let cache = cache as Any
            let imageSizePath = W200Path() as ImagePathProtocol
            let imageURL = movie.poster_path
            let args = ["imageURL": imageURL,
                        "imageSizePath": imageSizePath,
                        "cache": cache as Any]
            ImageView(viewModel: Resolver.resolve(name:.itemList, args:args))
                    .withRowImageSize()

            VStack(alignment:.leading){
                Text(movie.title)
                    .withRowTitleStyle()
                StarsVotedView(rating: movie.vote_average, voteCount: movie.vote_count)
                    .withRowStarsVotedSizeStyle()
            }
        }
        .padding()
    }
}

#if DEBUG
struct MovieRow_Previews: PreviewProvider {
    static var previews: some View {
        Resolver.setupPreviewMode()
        return Group{
            MovieRowView(movie: MoviesListViewModel.MovieItem.mock).preferredColorScheme(.dark)
            MovieRowView(movie: MoviesListViewModel.MovieItem.mock)
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
