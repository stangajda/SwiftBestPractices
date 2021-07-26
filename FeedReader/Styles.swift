//
//  Styles.swift
//  FeedReader
//
//  Created by Stan Gajda on 26/07/2021.
//
import SwiftUI

extension View {
    func withRowListStyles() -> some View {
            frame(maxWidth: .infinity, maxHeight: 96, alignment: .leading)
            .foregroundColor(.black)
            .font(.title)
            .padding()
    }
    
    func withRowImageSize() -> some View{
        frame(width: 64.0, height: 88.0)
    }
    
    func withMovieDetailsStyle() -> some View{
        frame(maxWidth: .infinity, maxHeight: 360.0, alignment: .top)
            .padding()
            .font(.body)
            .multilineTextAlignment(.center)
    }
}
