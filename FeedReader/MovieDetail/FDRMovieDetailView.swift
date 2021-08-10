//
//  FDRMovieDetailView.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/07/2021.
//

import SwiftUI
import Resolver

struct FDRMovieDetailView: View {
    @ObservedObject var viewModel: FDRMovieDetailViewModel
    @Environment(\.imageCache) var cache: FDRImageCacheInterface
    
    init(_ viewModel: FDRMovieDetailViewModel){
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

private extension FDRMovieDetailView {
    var initialView: some View {
        Color.clear
            .onAppear {
                viewModel.send(action: .onAppear)
            }
    }
    
    var loadingView: some View {
        FDRActivityIndicator(isAnimating: .constant(true), style: .large)
    }
    
    func loadedView(_ movieDetail: FDRMovieDetailViewModel.MovieDetailItem) -> some View {
        movieContent(movieDetail)
    }
    
    func failedView(_ error: Error) -> some View {
        FDRErrorView(error: error)
    }
    
    func movieContent(_ movieDetail: FDRMovieDetailViewModel.MovieDetailItem) -> some View {
        ScrollView {
            VStack(alignment: .leading){
                Text(viewModel.movieList.title)
                    .frame(maxWidth: .infinity, maxHeight: 20.0, alignment: .center)
                    .font(.title)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .padding()
                FDRImageView(viewModel: Resolver.resolve(name:.itemDetail,args:["imageURL": movieDetail.backdrop_path,"cache": cache as Any]))
                    .withMovieDetailsImageViewStyle()
                FDRStarsVotedView(rating: movieDetail.vote_average, voteCount: movieDetail.vote_count)
                    .frame(maxWidth: 180, maxHeight: 25.0, alignment: .leading)
                    .padding(.bottom)
                FDRIconValueView(iconName: "calendar", textValue: movieDetail.release_date)
                Text(movieDetail.overview)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom)
                if movieDetail.budget != "0" {
                    FDRIconValueView(iconName: "banknote", textValue: "$\(movieDetail.budget)")
                }
                FDRIconValueView(iconName: "speaker", textValue: movieDetail.spoken_languages)
                FDROverlayTextView(stringArray: movieDetail.genres)
            }
            .withMovieDetailsStyle()
        }
    }
}

#if DEBUG
struct FDRMovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Resolver.setupPreviewMode()
        return Group {
            FDRMovieDetailView(FDRMockMovieDetailViewModel(.loaded)).preferredColorScheme(.dark)
            FDRMovieDetailView(FDRMockMovieDetailViewModel(.loaded))
            FDRMovieDetailView(FDRMockMovieDetailViewModel(.loading))
            FDRMovieDetailView(FDRMockMovieDetailViewModel(.failedLoaded))
        }
    }
}
#endif
