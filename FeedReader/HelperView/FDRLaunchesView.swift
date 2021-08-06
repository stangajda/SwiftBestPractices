//
//  FDRLaunchesView.swift
//  FeedReader
//
//  Created by Stan Gajda on 06/08/2021.
//
import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
