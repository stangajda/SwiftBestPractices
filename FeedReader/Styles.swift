//
//  Styles.swift
//  FeedReader
//
//  Created by Stan Gajda on 26/07/2021.
//
import SwiftUI

extension View {
    func withTitleStyle() -> some View{
            frame(maxWidth: .infinity, maxHeight: 20.0, alignment: .center)
            .font(.largeTitle)
            .bold()
            .minimumScaleFactor(0.5)
            .lineLimit(1)
            .padding()
    }
    
    func withImageStyle() -> some View{
        frame(maxWidth: .infinity, minHeight: 220, alignment: .center)
            .padding(.bottom, 20.0)
    }
    
    func withOverviewStyle() -> some View{
        multilineTextAlignment(.leading)
        .font(.body)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.bottom)
    }
    
    func withStarsVotedSizeStyle(_ maxWidth: CGFloat, _ maxHeight: CGFloat) -> some View{
        frame(maxWidth: maxWidth, maxHeight: maxHeight, alignment: .leading)
        .font(.caption)
    }
    
    func withStarsVotedSizeStyle() -> some View{
        self.withStarsVotedSizeStyle(180, 25)
            .padding(.bottom)
    }
    
// MARK:- Row list
   
    func withRowTitleStyle() -> some View{
        font(.title2)
        .minimumScaleFactor(0.5)
    }
    
    func withRowImageSize() -> some View{
        frame(maxWidth: 64.0, maxHeight: 88.0)
    }
    
    func withRowStarsVotedSizeStyle() -> some View{
        self.withStarsVotedSizeStyle(140, 15)
    }
    
}
