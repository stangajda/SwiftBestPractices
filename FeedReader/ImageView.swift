//
//  ImageView.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/07/2021.
//

import SwiftUI

struct ImageView: View {
    @ObservedObject var service: ImageService = ImageService()
    @State var imageUrl: String
    
    var body: some View {
        if let image = service.image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }else{
            ActivityIndicator(isAnimating: .constant(true), style: .medium)
                .onAppear{
                service.loadImage(imageUrl)
            }
        }
    }
}

//struct ImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageView()
//    }
//}
