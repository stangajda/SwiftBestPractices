//
//  Extensions.swift
//  FeedReader
//
//  Created by Stan Gajda on 29/07/2023.
//

import Foundation
import SwiftUI

extension Text {
     func withTitleStyle<Content: AnyTitleStyleProtocol>(_ content: Content) -> some View {
         self.modifier(content)
     }

     func withOverviewStyle<Content: AnyOverviewStyleProtocol>(_ content: Content) -> some View {
         self.modifier(content)
     }
}

extension AsyncImageCached {
    func withImageStyle<Content: AnyImageStyleProtocol>(_ content: Content) -> some View {
        self.modifier(content)
    }
}

extension StarsVotedView {
     func withStarsVotedStyle<Content: AnyStarsVotedProtocol>(_ content: Content) -> some View {
         self.modifier(content)
     }
 }

extension View {
    func withStarsVotedSizeStyle<Content: AnyStarsVotedSizeProtocol>(_ content: Content) -> some View {
        self.modifier(content)
    }
}
