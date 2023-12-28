//
//  StylesStrucs.swift
//  FeedReader
//
//  Created by Stan Gajda on 29/07/2023.
//

import Foundation
import SwiftUI

// MARK: - StarsVotedSizeStyle

struct StarsVotedSizeStyle: StyleAnyViewProtocol {
    let maxWidth: CGFloat
    let maxHeight: CGFloat

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: maxWidth, maxHeight: maxHeight, alignment: .leading)
            .font(.caption)
    }
}

// MARK: - MovieDetailView styles

extension MovieDetailView {

    struct MovieDetailTitleStyle: StyleAnyTextProtocol {
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

    struct MovieDetailImageStyle: StyleAnyAsyncImageProtocol {
        func body(content: Content) -> some View {
            content
                .frame(maxWidth: .infinity, minHeight: 220)
                .padding(.bottom, 20.0)
        }
    }

    struct MovieDetailOverviewStyle: StyleAnyTextProtocol {
        func body(content: Content) -> some View {
            content
                .multilineTextAlignment(.leading)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom)
        }
    }

    struct MovieDetailStarsVotedStyle: StyleAnyStarsVotedProtocol {
        func body(content: Content) -> some View {
            content
                .withViewStyle(StarsVotedSizeStyle(maxWidth: 180.0, maxHeight: 25.0))
                .padding(.bottom)
        }
    }

}

// MARK: - MovieRowView styles

extension MovieRowView {

    struct MoviewRowTitleStyle: StyleAnyTextProtocol {
        func body(content: Content) -> some View {
            content
                .font(.title2)
                .minimumScaleFactor(0.5)
        }
    }

    struct MovieRowImageStyle: StyleAnyAsyncImageProtocol {
        func body(content: Content) -> some View {
            content
                .frame(maxWidth: 64.0, maxHeight: 88.0)
        }
    }

    struct MovieRowStarsVotedStyle: StyleAnyStarsVotedProtocol {
        func body(content: Content) -> some View {
            content
                .withViewStyle(StarsVotedSizeStyle(maxWidth: 140.0, maxHeight: 15.0))
        }
    }

}

// MARK: - Helpers View styles

extension StarsVotedView {
    struct StarsRatingViewStyle: StyleAnyStarsRatingViewProtocol {
        func body(content: Content) -> some View {
            content
                .frame(maxWidth: 120, maxHeight: 20.0, alignment: .leading)
        }
    }
}

extension StarsRatingView {
    struct StarsRatingImageStyle: StyleAnyImageProtocol {
        func body(content: Content) -> some View {
            content
                .aspectRatio(contentMode: .fit)
        }
    }
    struct StarsRatingMaskStyle: StyleAnyStarsRatingViewProtocol {
        func body(content: Content) -> some View {
            content
                .foregroundColor(.orange)
        }
    }
    struct StarsRatingOverlayStyle: StyleAnyViewProtocol {
        func body(content: Content) -> some View {
            content
                .foregroundColor(.gray)
        }
    }
}

extension ErrorView {
    struct ErrorViewTitleStyle: StyleAnyTextProtocol {
        func body(content: Content) -> some View {
            content
                .font(.headline)
                .minimumScaleFactor(0.5)
                .lineLimit(2)
                .padding(.bottom)
        }
    }

    struct ErrorViewDescriptionStyle: StyleAnyTextProtocol {
        func body(content: Content) -> some View {
            content
                .font(.callout)
                .minimumScaleFactor(0.5)
                .lineLimit(2)
                .padding(.bottom)
        }
    }
}

extension IconValueView {
    struct IconValueImageStyle: StyleAnyImageProtocol {
        func body(content: Content) -> some View {
            content
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.orange)
                .frame(maxWidth: 40, maxHeight: 25, alignment: .leading)
        }
    }
    struct IconValueTextStyle: StyleAnyTextProtocol {
        func body(content: Content) -> some View {
            content
                .font(.callout)
        }
    }
}

extension OverlayTextView {
    struct OverlayTextViewStyle: StyleAnyTextProtocol {
        func body(content: Content) -> some View {
            content
                .font(.caption)
                .padding(6.0)
                .foregroundColor(.primary)
                .overlay(
                    RoundedRectangle(cornerRadius: 10.0)
                        .stroke(lineWidth: 2.0)
                )
                .foregroundColor(.orange)
                .padding(.bottom)
        }
    }
}
