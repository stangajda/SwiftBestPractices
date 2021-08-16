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
    @Environment(\.imageCache) var cache: ImageCacheInterface
    
    init(_ viewModel: MovieDetailViewModel){
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack{
            content
        }
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear{
            viewModel.cancel()
        }
    }
    
    private var content: AnyView{
        switch viewModel.state {
        case .start:
            return AnyView(initialView)
        case .loading:
            return AnyView(loadingView)
        case .loaded(let movDetail):
            return AnyView(loadedView(movDetail))
        case .failedLoaded(let error):
            return AnyView(failedView(error))
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
                Text(viewModel.movieList.title)
                    .withMovieDetailsTitleStyle()
                
                ImageView(viewModel: Resolver.resolve(name:.itemDetail,args:["imageURL": movieDetail.backdrop_path,"imageSizePath": OriginalPath() as ImagePathInterface,"cache": cache as Any]))
                    .withMovieDetailsImageViewStyle()
                
                StarsVotedView(rating: movieDetail.vote_average, voteCount: movieDetail.vote_count)
                    .withMovieDetailsStarsVotedStyle()
                
                if movieDetail.release_date != "uknown"{
                    IconValueView(iconName: "calendar", textValue: movieDetail.release_date)
                }
                
                Text(movieDetail.overview)
                    .withMovieDetailsOverviewStyle()
                
                if movieDetail.budget != "0" {
                    IconValueView(iconName: "banknote", textValue: "$\(movieDetail.budget)")
                }
                
                IconValueView(iconName: "speaker", textValue: movieDetail.spoken_languages)
                
                OverlayTextView(stringArray: movieDetail.genres)
                
            }
            .withMovieDetailsStyle()
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
