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
        case .idle:
            return Color.clear
                        .onAppear {
                            viewModel.onAppear(url: imageUrl)
                        }
                        .eraseToAnyView()
        case .loading:
            return Spinner(isAnimating: .constant(true), style: .large)
                    .eraseToAnyView()
        case .loaded(let image):
            return Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .eraseToAnyView()
        case .failedLoaded(let error):
            return ErrorView(error: error).eraseToAnyView()
        }
    }
}

#if DEBUG
//struct ImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageView()
//    }
//}
#endif
