//
//  MoviesListView.swift
//  FeedReader
//
//  Created by Stan Gajda on 11/07/2021.
//

import SwiftUI

struct MoviesListView: View {
    @ObservedObject var viewModel: MoviesListViewModel = MoviesListViewModel()
    
    var body: some View {
        NavigationView {
            content
        }
        .onAppear{
            viewModel.send(event: .onAppear)
        }
    }
    
    private var content: some View{
        switch viewModel.state {
        case .idle:
            return AnyView(self)
        case .loading:
            return Spinner(isAnimating: .constant(true), style: .large).eraseToAnyView()
        case .loaded(let movies):
            return listMovies(movies)
        case .error(let error):
            return Text(error.localizedDescription).eraseToAnyView()
        }
    }
    
    
    private var listMovies = {(_ movies: [Movie]) -> AnyView in
        List(movies){ movie in
            NavigationLink(destination: MovieDetailView(movie: movie)){
                MovieRowView(movie: movie)
            }
        }.eraseToAnyView()
    }
    
}



struct MoviesList_Previews: PreviewProvider {
    static var previews: some View {
        MoviesListView()
    }
}
