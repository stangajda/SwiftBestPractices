//
//  MovieRowView.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/07/2021.
//

import SwiftUI
import PreviewSnapshots

//MARK:- MovieRowView
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
            .withAsyncImageStyle(MovieRowImageStyle())
            
            VStack(alignment:.leading){
                Text(movie.title)
                    .withTextStyle(MoviewRowTitleStyle())
                StarsVotedView(rating: movie.vote_average, voteCount: movie.vote_count)
                    .withStarsVotedStyle(MovieRowStarsVotedStyle())
            }
        }
        .padding()
    }
}

#if DEBUG
struct MovieRow_Previews: PreviewProvider {
    static var previews: some View {
        snapshots.previews.previewLayout(.sizeThatFits)
    }
    static var snapshots: PreviewSnapshots<Any> {
        return PreviewSnapshots(
            configurations: [
                .init()
            ],
            configure: { _ in
                MovieRowView(movie: MoviesListViewModel.MovieItem.mock)
            }
        )
    }
}
#endif
