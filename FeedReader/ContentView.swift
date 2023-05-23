//
//  ContentView.swift
//  FeedReader
//
//  Created by Stan Gajda on 16/06/2021.
//

import SwiftUI
import Resolver

struct ContentView: View {
    @InjectedSwinject var viewModel: AnyMoviesListViewModelProtocol
    var body: some View {
        MoviesListView(viewModel: viewModel)
    }
}
