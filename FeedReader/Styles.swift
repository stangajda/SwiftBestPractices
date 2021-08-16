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
            .font(.title)
            .minimumScaleFactor(0.5)
            .lineLimit(1)
            .padding()
    }
    
    func withSmallImageSize() -> some View{
        frame(maxWidth: 64.0, maxHeight: 88.0)
    }
    
    func withLargeImageStyle() -> some View{
        frame(maxWidth: .infinity, minHeight: 220, alignment: .center)
            .padding(.bottom, 20.0)
    }
    
// MARK:- Row list
    func withRowTitleStyle() -> some View{
        font(.title2)
        .minimumScaleFactor(0.5)
    }
    
    func withRowStyle() -> some View {
        frame(maxWidth: .infinity, minHeight: 88.0, alignment: .leading)
            .padding()
    }
    
    func withRowStarsVotedSize() -> some View{
        frame(maxWidth: 140, maxHeight: 15, alignment: .leading)
        .font(.caption)
    }
    
// MARK:- Movie Details
    func withMovieDetailStyle() -> some View{
        frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
            .font(.body)
            .multilineTextAlignment(.center)
    }
    
    func withMovieDetailsOverviewStyle() -> some View{
        multilineTextAlignment(.leading)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.bottom)
    }
    
    func withMovieDetailsStarsVotedStyle() -> some View{
        frame(maxWidth: 180, maxHeight: 25.0, alignment: .leading)
        .padding(.bottom)
    }
    
}
