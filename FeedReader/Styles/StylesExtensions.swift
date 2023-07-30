//
//  Extensions.swift
//  FeedReader
//
//  Created by Stan Gajda on 29/07/2023.
//

import Foundation
import SwiftUI

extension View {
    func withViewStyle<Content: StyleAnyViewProtocol>(_ content: Content) -> some View {
        self.modifier(content)
    }
}

extension Image {
    func withImageStyle<Content: StyleAnyImageProtocol>(_ content: Content) -> some View {
        self.modifier(content)
    }
}

extension Text {
     func withTextStyle<Content: StyleAnyTextProtocol>(_ content: Content) -> some View {
         self.modifier(content)
     }
}

extension AsyncImageCached {
    func withAsyncImageStyle<Content: StyleAnyAsyncImageProtocol>(_ content: Content) -> some View {
        self.modifier(content)
    }
}

extension StarsVotedView {
     func withStarsVotedStyle<Content: StyleAnyStarsVotedProtocol>(_ content: Content) -> some View {
         self.modifier(content)
     }
 }

extension StarsRatingView {
    func withStarsRatingViewStyle<Content: StyleAnyStarsRatingViewProtocol>(_ content: Content) -> some View {
        self.modifier(content)
    }
}

extension StarsRatingMask {
    func withStarsRatingViewStyle<Content: StyleAnyStarsRatingViewProtocol>(_ content: Content) -> some View {
        self.modifier(content)
    }
}

