//
//  ImageView.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/07/2021.
//

import SwiftUI
//MARK:- ImageViewModel
struct AsyncImageCached<ViewModel,ImageLoadingView: View, ImageErrorView: View>: View where ViewModel: ImageViewModelProtocol{
    @ObservedObject private var viewModel: ViewModel
    private let cancelOnDisapear: Bool = false
    private var placeholderLoading: ImageLoadingView
    private var placeholderError: (Error) -> ImageErrorView


//MARK:- Path initialiser
    init (imageURL: String, imageSizePath: ImagePathProtocol, cancelOnDisapear: Bool = false, @ViewBuilder placeholderLoading: () -> ImageLoadingView, @ViewBuilder placeholderError: @escaping (Error) -> ImageErrorView) {

        let cache: ImageCacheProtocol? = Environment (\.imageCache).wrappedValue
        let imageViewModel: AnyImageViewModelProtocol = Injection.shared.container.resolve(AnyImageViewModelProtocol.self, arguments: imageURL, imageSizePath, cache)
        
        self.init(viewModel: imageViewModel, placeholderLoading: placeholderLoading, placeholderError: placeholderError)
        
    }
    
//MARK:- viewModel initialiser
    init(viewModel: AnyImageViewModelProtocol, @ViewBuilder placeholderLoading: () -> ImageLoadingView, @ViewBuilder placeholderError: @escaping (Error) -> ImageErrorView) {
            self.placeholderLoading = placeholderLoading ()
            self.placeholderError = placeholderError
        
            let imageViewModel = viewModel
            guard let wrappedValue = AnyImageViewModelProtocol(imageViewModel) as? ViewModel else {
                fatalError ("ImageViewModel not found")
            }
            _viewModel = ObservedObject (wrappedValue: wrappedValue)
    }
    
    var body: some View {
        content
            .onAppear {
                viewModel.send(action: .onAppear)
            }
            .onDisappear{
                cancelOnDisapear ? viewModel.send(action: .onReset) : ()
            }
    }

//MARK:- Content
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

//MARK:- States
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
        return Group {
            let _ = Injection.shared.setupPreviewMode()
            AsyncImageCached<AnyImageViewModelProtocol, ActivityIndicator, ErrorView>(imageURL: "", imageSizePath: OriginalPath()) {
                ActivityIndicator(isAnimating: .constant(true), style: .large)
            } placeholderError: { error in
                ErrorView(error: error)
            }
            
            let _ = Injection.shared.setupPreviewModeDetail()
            AsyncImageCached<AnyImageViewModelProtocol, ActivityIndicator, ErrorView>(imageURL: "", imageSizePath: OriginalPath()) {
                ActivityIndicator(isAnimating: .constant(true), style: .large)
            } placeholderError: { error in
                ErrorView(error: error)
            }
        }
    }
}

#endif
