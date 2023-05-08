//
//  MovieDetailView.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/07/2021.
//

import SwiftUI
import Resolver

struct MovieDetailView<ViewModel>: View where ViewModel: MovieDetailViewModelProtocol {
    @ObservedObject var viewModel: ViewModel
    
    init(_ viewModel: ViewModel){
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
            viewModel.send(action: .onReset)
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
                
                let imageSizePath = OriginalPath() as ImagePathProtocol
                let imageURL = movieDetail.backdrop_path
                
                AsyncImageCached(imageURL: imageURL, imageSizePath: imageSizePath) {
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                } placeholderError: { error in
                    ErrorView(error: error)
                }
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
        @Injected(name: .movieDetailStateLoaded) var viewModelLoaded: MovieDetailViewModelWrapper
        @Injected(name: .movieDetailStateLoading) var viewModelLoading: MovieDetailViewModelWrapper
        @Injected(name: .movieDetailStateFailed) var viewModelFailedLoaded: MovieDetailViewModelWrapper

        return Group {
             MovieDetailView(viewModelLoaded)
                .previewDisplayName("MovieDetailView loaded")
             MovieDetailView(viewModelLoading)
                .previewDisplayName("MovieDetailView loading")
             MovieDetailView(viewModelFailedLoaded)
                .previewDisplayName("MovieDetailView failed")
        }
    }
}
#endif
