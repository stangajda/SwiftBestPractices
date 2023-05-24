//
//  ContentView.swift
//  FeedReader
//
//  Created by Stan Gajda on 16/06/2021.
//

import SwiftUI

struct ContentView: View {
    @Injected var viewModel: AnyMoviesListViewModelProtocol
    var body: some View {
        MoviesListView(viewModel: viewModel)
    }
}
