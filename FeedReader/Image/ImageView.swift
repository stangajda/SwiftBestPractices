//
//  ImageView.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/07/2021.
//

import SwiftUI

struct ImageView: View {
    @ObservedObject var viewModel: ImageViewModel = ImageViewModel()
    @State var imageUrl: String
    
    var body: some View {
        content
    }
    
    private var content: AnyView {
        switch viewModel.state {
        case .initial:
            return AnyView(initialView)
        case .loading:
            return AnyView(loadingView)
        case .loaded(let image):
            return AnyView(loadedView(image))
        case .failedLoaded(let error):
            return AnyView(failedView(error))
        }
    }
}

private extension ImageView {
    var initialView: some View {
        Color.clear
            .onAppear {
                viewModel.onAppear(url: imageUrl)
            }
    }
    
    var loadingView: some View {
        ActivityIndicator(isAnimating: .constant(true), style: .large)
    }
    
    func loadedView(_ image: Image) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(error: error)
    }
    
}

#if DEBUG
//struct ImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageView()
//    }
//}
#endif
