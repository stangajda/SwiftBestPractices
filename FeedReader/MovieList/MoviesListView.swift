//
//  MoviesListView.swift
//  FeedReader
//
//  Created by Stan Gajda on 11/07/2021.
//

import SwiftUI
import Resolver

struct MoviesListView: View {
    @ObservedObject var viewModel: MoviesListViewModel
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        NavigationStack(){
            content
                .navigationTitle(MOVIELIST_TITLE)
                .navigationBarTitleDisplayMode(.inline)
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
        Resolver.setupPreviewMode()
        return Group {
            MoviesListView(viewModel: MockMoviesListViewModel(.loaded)).preferredColorScheme(.dark)
            MoviesListView(viewModel: MockMoviesListViewModel(.loaded))
            MoviesListView(viewModel: MockMoviesListViewModel(.loading))
            MoviesListView(viewModel: MockMoviesListViewModel(.failedLoaded))
        }
    }
}
#endif
