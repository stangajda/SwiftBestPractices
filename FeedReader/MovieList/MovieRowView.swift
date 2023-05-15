//
//  MovieRowView.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/07/2021.
//

import SwiftUI
import Resolver

struct MovieRowView: View {
    typealias AsyncImage = AsyncImageCached<AnyImageViewModelProtocol, ActivityIndicator, ErrorView>
    @State var movie: MoviesListViewModel.MovieItem
    
    var body: some View {
        HStack{
            let imageSizePath = W200Path() as ImagePathProtocol
            let imageURL = movie.poster_path
            
            AsyncImage(imageURL: imageURL, imageSizePath: imageSizePath) {
                ActivityIndicator(isAnimating: .constant(true), style: .medium)
            } placeholderError: { error in
                ErrorView(error: error)
            }
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
            MovieRowView(movie: MoviesListViewModel.MovieItem.mock)
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
