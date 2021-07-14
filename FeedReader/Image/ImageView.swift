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
        switch viewModel.state{
        case .idle:
            Color.clear.eraseToAnyView()
                .onAppear{
                    viewModel.onAppear(url: imageUrl)
                }
        case .loading:
            Spinner(isAnimating: .constant(true), style: .large)
        case .loaded(let image):
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        case .failedLoaded(let error):
            Text(verbatim: error.localizedDescription)
        }
    }
}


//struct ImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageView()
//    }
//}
