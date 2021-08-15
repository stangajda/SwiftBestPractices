//
//  FDRStyles.swift
//  FeedReader
//
//  Created by Stan Gajda on 26/07/2021.
//
import SwiftUI

extension View {
    
// MARK:- Row list
    func withRowListStyles() -> some View {
        frame(maxWidth: .infinity, minHeight: 88.0, alignment: .leading)
            .font(.title)
            .padding()
    }
    
    func withRowListImageSize() -> some View{
        frame(maxWidth: 64.0, maxHeight: 88.0)
    }
    
    func withRowTitleSize() -> some View{
        font(.title2)
        .minimumScaleFactor(0.5)
    }
    
    func withRowStarsVotedSize() -> some View{
        frame(maxWidth: 140, maxHeight: 15, alignment: .leading)
        .font(.caption)
    }
    
// MARK:- Movie Details
    func withMovieDetailsStyle() -> some View{
        frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
            .font(.body)
            .multilineTextAlignment(.center)
    }
    
    func withMovieDetailsTitleStyle() -> some View{
        frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .frame(maxWidth: .infinity, maxHeight: 20.0, alignment: .center)
            .font(.title)
            .minimumScaleFactor(0.5)
            .lineLimit(1)
            .padding()
    }
    
    func withMovieDetailsImageViewStyle() -> some View{
        frame(maxWidth: .infinity, minHeight: 220, alignment: .center)
            .padding(.bottom, 20.0)
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

// MARK: Image
extension Image{
    func withImageStyles() -> some View{
        resizable()
            .aspectRatio(contentMode: .fit)
    }
}
