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
                    viewModel.reset()
                }
            }
            .onDisappear{
                viewModel.reset()
            }
    }
    
}

private extension MoviesListView {
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
                LazyView(MovieDetailView(MovieDetailViewModel(movieList: movie)))
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
}


#if DEBUG
struct MoviesList_Previews: PreviewProvider {
    static var previews: some View {
        @Injected var viewModel: MoviesListViewModelWrapper
        Resolver.setupPreviewMode()
        return Group {
            MoviesListView(viewModel: viewModel)
        }
    }
}
#endif
