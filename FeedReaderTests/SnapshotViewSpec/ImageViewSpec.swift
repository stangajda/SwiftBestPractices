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
import Nimble_SnapshotTesting

class MovieImageViewSpec: QuickSpec {
    override func spec() {
        describe("check image view to match recorded snapshot") {
            var viewController: UIViewController!

            context("when image is in preview mode") {
                beforeEach { @MainActor in
                    Injection.main.setupPreviewMode()
                    let imageView = AsyncImageCached<AnyImageViewModelProtocol, ActivityIndicator, ErrorView>(imageURL: "", imageSizePath: OriginalPath()) {
                        ActivityIndicator(isAnimating: .constant(true), style: .large)
                    } placeholderError: { error in
                        ErrorView(error: error)
                    }
                    viewController = UIHostingController(rootView: imageView)
                }

                it("it should match recorded image") { @MainActor in
                    expect(viewController).to(haveValidSnapshot(as: .image))
                }
            }
            
            context("when image is in preview mode detail") {
                beforeEach { @MainActor in
                    Injection.main.setupPreviewModeDetail()
                    let imageView = AsyncImageCached<AnyImageViewModelProtocol, ActivityIndicator, ErrorView>(imageURL: "", imageSizePath: OriginalPath()) {
                        ActivityIndicator(isAnimating: .constant(true), style: .large)
                    } placeholderError: { error in
                        ErrorView(error: error)
                    }
                    viewController = UIHostingController(rootView: imageView)
                }

                it("it should match recorded image") { @MainActor in
                    expect(viewController).to(haveValidSnapshot(as: .image))
                }
            }
            
        }
    }
}
