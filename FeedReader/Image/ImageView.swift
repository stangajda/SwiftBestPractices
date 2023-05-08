//
//  ImageView.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/07/2021.
//

import SwiftUI

struct AsyncImageCached<ViewModel,ImageLoadingView: View, ImageErrorView: View>: View where ViewModel: ImageViewModelProtocol{
    @ObservedObject private var viewModel: ViewModel
    private let placeholderLoading: ImageLoadingView
    private let placeholderError: (Error) -> ImageErrorView


    
    init (imageURL: String, imageSizePath: ImagePathProtocol, @ViewBuilder placeholderLoading: () -> ImageLoadingView, @ViewBuilder placeholderError: @escaping (Error) -> ImageErrorView) {
        self.placeholderLoading = placeholderLoading ()
        self.placeholderError = placeholderError

        let cache = Environment (\.imageCache).wrappedValue
        guard let wrappedValue = ImageViewModel (imagePath: imageURL, imageSizePath: imageSizePath, cache: cache) as? ViewModel else {
            fatalError ("ImageViewModel not found")
        }
        
        _viewModel = ObservedObject (wrappedValue: wrappedValue)
    }
    
    var body: some View {
        content
            .onAppear {
                viewModel.send(action: .onAppear)
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

private extension AsyncImageCached {
    var initialView: some View {
        Color.clear
    }
    
    var loadingView: some View {
        placeholderLoading
    }
    
    func loadedView(_ image: Image) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
    func failedView(_ error: Error) -> some View {
        placeholderError(error)
    }
    
}

#if DEBUG
struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
//            ImageView(viewModel: MockImageViewModel(.itemDetail))
        }
    }
}
#endif
