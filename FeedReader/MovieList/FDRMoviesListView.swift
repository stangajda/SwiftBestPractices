//
//  FDRMoviesListView.swift
//  FeedReader
//
//  Created by Stan Gajda on 11/07/2021.
//

import SwiftUI
import Resolver

struct FDRMoviesListView: View {
    @ObservedObject var viewModel: FDRMoviesListViewModel
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        NavigationView {
            content
                .navigationBarTitle("Trending Daily")
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                viewModel.send(action: .onAppear)
            } else if newPhase == .background {
                viewModel.send(action: .onReset)
            }
        }
    }
    
    private var content: AnyView{
        switch viewModel.state {
        case .start:
            return AnyView(startView)
        case .loading:
            return AnyView(loadingView)
        case .loaded(let movies):
            return AnyView(loadedView(movies))
        case .failedLoaded(let error):
            return AnyView(failedView(error))
        }
    }
    
}

private extension FDRMoviesListView {
    var startView: some View {
        Color.clear
            .onAppear {
                viewModel.send(action: .onAppear)
            }
    }
    
    var loadingView: some View {
        FDRActivityIndicator(isAnimating: .constant(true), style: .large)
    }
    
    func loadedView(_ movies: Array<FDRMoviesListViewModel.MovieItem>) -> some View {
        listMovies(movies)
    }
    
    func failedView(_ error: Error) -> some View {
        FDRErrorView(error: error)
    }
    
    func listMovies(_ movies: Array<FDRMoviesListViewModel.MovieItem>) -> some View {
        List(movies){ movie in
            NavigationLink(destination: LazyView(FDRMovieDetailView( FDRMovieDetailViewModel(movieList: movie))),
                           label: {FDRMovieRowView(movie: movie)}
            )
        }
    }
}


#if DEBUG
struct FDRMoviesList_Previews: PreviewProvider {
    static var previews: some View {
        Resolver.setupPreviewMode()
        return Group {
            FDRMoviesListView(viewModel: FDRMockMoviesListViewModel(.loaded)).preferredColorScheme(.dark)
            FDRMoviesListView(viewModel: FDRMockMoviesListViewModel(.loaded))
            FDRMoviesListView(viewModel: FDRMockMoviesListViewModel(.loading))
            FDRMoviesListView(viewModel: FDRMockMoviesListViewModel(.failedLoaded))
        }
    }
}
#endif
