//
//  FDRImageView.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/07/2021.
//

import SwiftUI

struct FDRImageView: View {
    @ObservedObject var viewModel: FDRImageViewModel
    
    var body: some View {
        content
            .onDisappear{
                viewModel.cancel()
            }
    }
    
    private var content: AnyView {
        switch viewModel.state {
        case .start:
            return AnyView(initialView)
        case .loading:
            return AnyView(loadingView)
        case .loaded(let image):
            return AnyView(loadedView(image.image))
        case .failedLoaded(let error):
            return AnyView(failedView(error))
        }
    }
}

private extension FDRImageView {
    var initialView: some View {
        Color.clear
    }
    
    var loadingView: some View {
        FDRActivityIndicator(isAnimating: .constant(true), style: .large)
    }
    
    func loadedView(_ image: Image) -> some View {
        image
            .withImageStyles()
    }
    
    func failedView(_ error: Error) -> some View {
        FDRErrorView(error: error)
    }
    
}

#if DEBUG
//struct ImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageView()
//    }
//}
#endif
