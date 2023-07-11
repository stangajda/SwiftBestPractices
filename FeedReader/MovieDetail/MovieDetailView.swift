//
//  MovieDetailView.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/07/2021.
//

import SwiftUI

//MARK:- Main
struct MovieDetailView<ViewModel>: View where ViewModel: AnyMovieDetailViewModelProtocol {
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
            viewModel.onDisappear()
        }
    }
    
}

//MARK:- States
private extension MovieDetailView {
    typealias AsyncImage = AsyncImageCached<AnyImageViewModelProtocol, ActivityIndicator, ErrorView>
    
    @ViewBuilder
    var initialView: some View {
        Color.clear
            .onAppear {
                viewModel.onAppear()
            }
    }
    
    @ViewBuilder
    var loadingView: some View {
        ActivityIndicator(isAnimating: .constant(true), style: .large)
    }
    
    @ViewBuilder
    func loadedView(_ movieDetail: MovieDetailViewModel.MovieDetailItem) -> some View {
        movieContent(movieDetail)
    }
    
    @ViewBuilder
    func failedView(_ error: Error) -> some View {
        ErrorView(error: error)
    }
    
    
    func movieContent(_ movieDetail: MovieDetailViewModel.MovieDetailItem) -> some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(movieDetail.title)
                    .withTitleStyle()
                
                let imageSizePath = OriginalPath() as ImagePathProtocol
                let imageURL = movieDetail.backdrop_path
                
                AsyncImage(imageURL: imageURL, imageSizePath: imageSizePath) {
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                } placeholderError: { error in
                    ErrorView(error: error)
                }
                .withImageStyle()
                
                StarsVotedView(rating: movieDetail.vote_average, voteCount: movieDetail.vote_count)
                    .withStarsVotedSizeStyle()
                
                if !movieDetail.release_date.isEmpty{
                    IconValueView(iconName: Config.Icon.calendar, textValue: movieDetail.release_date)
                }
                
                Text(movieDetail.overview)
                    .withOverviewStyle()
                
                if movieDetail.budget.isNotZero() {
                    IconValueView(iconName: Config.Icon.banknote, textValue: movieDetail.budget.addDollar())
                }
                
                IconValueView(iconName: Config.Icon.speaker, textValue: movieDetail.spoken_languages)
                
                OverlayTextView(stringArray: movieDetail.genres)
            }
            .padding()
        }
    }
}

#if DEBUG
struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Injection.main.setupPreviewModeDetail()
        @Injected(name: .movieDetailStateLoaded) var viewModelLoaded: AnyMovieDetailViewModelProtocol
        @Injected(name: .movieDetailStateLoading) var viewModelLoading: AnyMovieDetailViewModelProtocol
        @Injected(name: .movieDetailStateFailed) var viewModelFailedLoaded: AnyMovieDetailViewModelProtocol

        return Group {
             MovieDetailView(viewModelLoaded)
                .previewDisplayName(Config.View.MovieList.loaded)
             MovieDetailView(viewModelLoading)
                .previewDisplayName(Config.View.MovieList.loading)
             MovieDetailView(viewModelFailedLoaded)
                .previewDisplayName(Config.View.MovieList.loaded)
        }
    }
}
#endif
