//
//  StylesStrucs.swift
//  FeedReader
//
//  Created by Stan Gajda on 29/07/2023.
//

import Foundation
import SwiftUI

struct StarsVotedSizeStyle: AnyStarsVotedSizeProtocol {
    let maxWidth: CGFloat
    let maxHeight: CGFloat
    
    init(_ maxWidth: CGFloat, _ maxHeight: CGFloat) {
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
    }
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: maxWidth, maxHeight: maxHeight, alignment: .leading)
            .font(.caption)
    }
}

extension MovieDetailView {
    
    struct TitleStyle: AnyTitleStyleProtocol {
        func body(content: Content) -> some View {
            content
                .frame(maxWidth: .infinity, maxHeight: 20.0)
                .font(.largeTitle)
                .bold()
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .padding()
        }
    }
    
    struct ImageStyle: AnyImageStyleProtocol {
        func body(content: Content) -> some View {
            content
                .frame(maxWidth: .infinity, minHeight: 220)
                .padding(.bottom, 20.0)
        }
    }
    
    struct OverviewStyle: AnyOverviewStyleProtocol {
        func body(content: Content) -> some View {
            content
                .multilineTextAlignment(.leading)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom)
        }
    }
    
    struct StarsVotedStyle: AnyStarsVotedProtocol {
        func body(content: Content) -> some View {
            content
                .withStarsVotedSizeStyle(StarsVotedSizeStyle(180.0, 25.0))
                .padding(.bottom)
        }
    }
    
}

extension MovieRowView {
    
    struct TitleStyle: AnyTitleStyleProtocol {
        func body(content: Content) -> some View {
            content
                .font(.title2)
                .minimumScaleFactor(0.5)
        }
    }

    struct ImageStyle: AnyImageStyleProtocol {
        func body(content: Content) -> some View {
            content
                .frame(maxWidth: 64.0, maxHeight: 88.0)
        }
    }

    struct StarsVotedStyle: AnyStarsVotedProtocol {
        func body(content: Content) -> some View {
            content
                .withStarsVotedSizeStyle(StarsVotedSizeStyle(140.0, 15.0))
        }
    }
    
}
