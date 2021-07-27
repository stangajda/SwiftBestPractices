//
//  Styles.swift
//  FeedReader
//
//  Created by Stan Gajda on 26/07/2021.
//
import SwiftUI

extension View {
    func withRowListStyles() -> some View {
        frame(maxWidth: .infinity, minHeight: 88.0, alignment: .leading)
            .foregroundColor(.black)
            .font(.title)
            .padding()
    }
    
    func withRowListImageSize() -> some View{
        frame(maxWidth: 64.0, maxHeight: 88.0)
    }
    
    func withMovieDetailsStyle() -> some View{
        frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
            .font(.body)
            .multilineTextAlignment(.center)
    }
    
    func withMovieDetailsImageViewStyle() -> some View{
        frame(maxWidth: .infinity, minHeight: 200, alignment: .center)
            .padding(.bottom, 20.0)
    }
    
}

extension Image{
    func withImageStyles() -> some View{
        resizable()
            .aspectRatio(contentMode: .fit)
    }
}
