//
//  FDRContentView.swift
//  FeedReader
//
//  Created by Stan Gajda on 16/06/2021.
//

import SwiftUI
import Resolver

struct FDRContentView: View {
    @Injected var viewModel: FDRMoviesListViewModel
    var body: some View {
        FDRMoviesListView(viewModel: viewModel)
    }
}
