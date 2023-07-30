//
//  StylesStrucs.swift
//  FeedReader
//
//  Created by Stan Gajda on 29/07/2023.
//

import Foundation
import SwiftUI

// MARK: - StarsVotedSizeStyle

struct StarsVotedSizeStyle: AnyStarsVotedSizeProtocol {
    let maxWidth: CGFloat
    let maxHeight: CGFloat
    
    init(maxWidth: CGFloat, maxHeight: CGFloat) {
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
    }
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: maxWidth, maxHeight: maxHeight, alignment: .leading)
            .font(.caption)
    }
}

// MARK: - MovieDetailView styles

extension MovieDetailView {
    
    struct MovieDetailTitleStyle: AnyTitleStyleProtocol {
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
    
    struct MovieDetailImageStyle: AnyAsyncImageStyleProtocol {
        func body(content: Content) -> some View {
            content
                .frame(maxWidth: .infinity, minHeight: 220)
                .padding(.bottom, 20.0)
        }
    }
    
    struct MovieDetailOverviewStyle: AnyOverviewStyleProtocol {
        func body(content: Content) -> some View {
            content
                .multilineTextAlignment(.leading)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom)
        }
    }
    
    struct MovieDetailStarsVotedStyle: AnyStarsVotedProtocol {
        func body(content: Content) -> some View {
            content
                .withStarsVotedSizeStyle(StarsVotedSizeStyle(maxWidth: 180.0, maxHeight: 25.0))
                .padding(.bottom)
        }
    }
    
}

// MARK: - MovieRowView styles

extension MovieRowView {
    
    struct MoviewRowTitleStyle: AnyTitleStyleProtocol {
        func body(content: Content) -> some View {
            content
                .font(.title2)
                .minimumScaleFactor(0.5)
        }
    }

    struct MovieRowImageStyle: AnyAsyncImageStyleProtocol {
        func body(content: Content) -> some View {
            content
                .frame(maxWidth: 64.0, maxHeight: 88.0)
        }
    }

    struct MovieRowStarsVotedStyle: AnyStarsVotedProtocol {
        func body(content: Content) -> some View {
            content
                .withStarsVotedSizeStyle(StarsVotedSizeStyle(maxWidth: 140.0, maxHeight: 15.0))
        }
    }
    
}

// MARK: - Helpers View styles

struct StarsRatingViewStyle: AnyStarsRatingViewProtocol {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: 120, maxHeight: 20.0, alignment: .leading)
    }
}

struct StarsRatingImageStyle: AnyImageStyleProtocol {
    func body(content: Content) -> some View {
        content
            .aspectRatio(contentMode: .fit)
    }
}
