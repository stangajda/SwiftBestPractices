//
//  MovieDetailViewSpec.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 06/07/2023.
//

import Foundation
@testable import FeedReader
import SwiftUI
import Nimble
import Quick
import SnapshotTesting

class MovieDetailViewSpec: QuickSpec {
    override func spec() {
        describe("check movie detail view to match recorded snapshot") {
                    
            var viewController: UIViewController!

            beforeEach { @MainActor in
                Injection.main.setupPreviewModeDetail()
            }

            context("when movie detail is loaded") {
                beforeEach { @MainActor in
                    @Injected(name: .movieDetailStateLoaded) var viewModelLoaded: AnyMovieDetailViewModelProtocol
                    viewController = UIHostingController(rootView: MovieDetailView(viewModelLoaded))
                }

                it("it should match recorded image") { @MainActor in
                    assertSnapshot(matching: viewController, as: .image)
                }
            }
        }
    }
}
