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
    @Environment(\.imageCache) var cache: ImageCache
    
    init(_ viewModel: MovieDetailViewModel){
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack{
            content
        }
        .navigationTitle(viewModel.movieList.title)
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
                ImageView(viewModel: Resolver.resolve(name:.itemDetail,args:["imageURL": movieDetail.backdrop_path,"cache": cache as Any]))
                    .withMovieDetailsImageViewStyle()
                HStack(){
                    StarsRatingView(rating: 3.7, maxRating: 5)
                        .frame(maxWidth: 100, maxHeight: 20.0, alignment: .leading)
                        Text("(212)")
                }
                .padding(.bottom)
                Text("budget $17,739,525")
                    .padding(.bottom)
                Text(movieDetail.overview)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom)
                Text("released 30 July 21")
                    .padding(.bottom)
                VStack(alignment: .leading){
                    Text("horror, thriller, action")
                    Text("tagline: Hibernate. Inject. Survive. Shoot.")
                }
                .font(.callout)
                .padding(.bottom)
                Text("languages: Deutch, English")
                    .font(.callout)
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
            MovieDetailView(MockMovieDetailViewModel(.loaded))
            MovieDetailView(MockMovieDetailViewModel(.loading))
            MovieDetailView(MockMovieDetailViewModel(.failedLoaded))
        }
    }
}
#endif
