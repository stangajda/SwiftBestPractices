//
//  MoviesListView.swift
//  FeedReader
//
//  Created by Stan Gajda on 11/07/2021.
//

import SwiftUI
import Resolver

struct MoviesListView<ViewModel>: View where ViewModel: MoviesListViewModelProtocol {
    @ObservedObject var viewModel: ViewModel
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
            NavigationStack(){
                switch viewModel.state {
                case .start:
                    startView
                case .loading:
                    loadingView
                case .loaded(let movies):
                    loadedView(movies)
                        .navigationTitle(MOVIELIST_TITLE)
                        .navigationBarTitleDisplayMode(.inline)
                case .failedLoaded(let error):
                    failedView(error)
                }
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    viewModel.send(action: .onAppear)
                } else if newPhase == .background {
                    viewModel.send(action: .onReset)
                }
            }
            .onDisappear{
                viewModel.send(action: .onReset)
            }
    }
    
}

extension MoviesListView {
    typealias MovieDetailViewWrapper = MovieDetailView<MovieDetailViewModelWrapper>
    var startView: some View {
        Color.clear
            .onAppear {
                viewModel.send(action: .onAppear)
            }
    }
    
    var loadingView: some View {
        ActivityIndicator(isAnimating: .constant(true), style: .large)
    }
    
    func loadedView(_ movies: Array<MoviesListViewModel.MovieItem>) -> some View {
        listMovies(movies)
            .navigationDestination(for: MoviesListViewModel.MovieItem.self) { movie in
                makeMovieDetailView(for: movie)
            }
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(error: error)
    }
    
    func listMovies(_ movies: Array<MoviesListViewModel.MovieItem>) -> some View {
        List(movies){ movie in
            NavigationLink(value: movie) {
                MovieRowView(movie: movie)
            }
        }
    }
    
    func makeMovieDetailView(for movie: MoviesListViewModel.MovieItem) -> some View {
        LazyView(MovieDetailViewWrapper(Resolver.resolve(args: [DI_MOVIE_LIST: movie])))
    }
}


#if DEBUG
struct MoviesList_Previews: PreviewProvider {
    static var previews: some View {
        Resolver.setupPreviewMode()
        @Injected(name: .movieListStateLoaded) var viewModelLoaded: MoviesListViewModelWrapper
        @Injected(name: .movieListStateLoading) var viewModelLoading: MoviesListViewModelWrapper
        @Injected(name: .movieListStateFailed) var viewModelFailed: MoviesListViewModelWrapper
        
        return Group {
            MoviesListView(viewModel: viewModelLoaded)
                .previewDisplayName(VIEW_MOVIE_LIST_LOADED)
            MoviesListView(viewModel: viewModelLoading)
                .previewDisplayName(VIEW_MOVIE_LIST_LOADING)
            MoviesListView(viewModel: viewModelFailed)
                .previewDisplayName(VIEW_MOVIE_LIST_FAILED)
        }
        
    }
}
#endif
