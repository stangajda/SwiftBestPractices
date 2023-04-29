//
//  MovieDetailView.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/07/2021.
//

import SwiftUI
import Resolver

struct MovieDetailView: View {
    @ObservedObject var viewModel: MovieDetailViewModel
    @Environment(\.imageCache) var cache: ImageCacheProtocol
    
    init(_ viewModel: MovieDetailViewModel){
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack{
            switch viewModel.state {
            case .start:
                initialView
            case .loading:
                loadingView
            case .loaded(let movDetail):
                loadedView(movDetail)
            case .failedLoaded(let error):
                failedView(error)
            }
        }
        .onDisappear{
            viewModel.cancel()
        }
    }
    
}

private extension MovieDetailView {
    var initialView: some View {
        Color.clear
            .onAppear {
                viewModel.send(action: .onAppear)
            }
    }
    
    var loadingView: some View {
        ActivityIndicator(isAnimating: .constant(true), style: .large)
    }
    
    func loadedView(_ movieDetail: MovieDetailViewModel.MovieDetailItem) -> some View {
        movieContent(movieDetail)
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(error: error)
    }
    
    func movieContent(_ movieDetail: MovieDetailViewModel.MovieDetailItem) -> some View {
        ScrollView {
            VStack(alignment: .leading){
                Text(movieDetail.title)
                    .withTitleStyle()
                
                let cache = cache as Any
                let imageSizePath = OriginalPath() as ImagePathProtocol
                let imageURL = movieDetail.backdrop_path
                let args = ["imageURL": imageURL,
                            "imageSizePath": imageSizePath,
                            "cache": cache as Any]
                ImageView(viewModel: Resolver.resolve(name:.itemDetail, args:args))
                    .withImageStyle()
                
                StarsVotedView(rating: movieDetail.vote_average, voteCount: movieDetail.vote_count)
                    .withStarsVotedSizeStyle()
                
                if movieDetail.release_date != "uknown"{
                    IconValueView(iconName: "calendar", textValue: movieDetail.release_date)
                }
                
                Text(movieDetail.overview)
                    .withOverviewStyle()
                
                if movieDetail.budget != "0" {
                    IconValueView(iconName: "banknote", textValue: "$\(movieDetail.budget)")
                }
                
                IconValueView(iconName: "speaker", textValue: movieDetail.spoken_languages)
                
                OverlayTextView(stringArray: movieDetail.genres)
                
            }
            .padding()

        }
    }
}

#if DEBUG
struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Resolver.setupPreviewMode()
        return Group {
            MovieDetailView(MockMovieDetailViewModel(.loaded)).preferredColorScheme(.dark)
            MovieDetailView(MockMovieDetailViewModel(.loaded))
            MovieDetailView(MockMovieDetailViewModel(.loading))
            MovieDetailView(MockMovieDetailViewModel(.failedLoaded))
        }
    }
}
#endif
