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
    override class func spec() {
        describe("check image view to match recorded snapshot") {
            var viewController: UIViewController!

            context("when image is in preview mode") {
                beforeEach {
                    Injection.main.mockViewModel()
                    let imageView = AsyncImageCached<AnyImageViewModelProtocol, ActivityIndicator, ErrorView>(imageURL: "", imageSizePath: OriginalPath()) {
                        ActivityIndicator(isAnimating: .constant(true), style: .large)
                    } placeholderError: { error in
                        ErrorView(error: error)
                    }
                    viewController = UIHostingController(rootView: imageView)
                }

                it("it should match recorded image") {
                    expect(viewController).toEventually(haveValidSnapshot(as: .image))
                }
            }
            
            context("when image is in preview mode detail") {
                beforeEach {
                    Injection.main.mockDetailViewModel()
                    let imageView = AsyncImageCached<AnyImageViewModelProtocol, ActivityIndicator, ErrorView>(imageURL: "", imageSizePath: OriginalPath()) {
                        ActivityIndicator(isAnimating: .constant(true), style: .large)
                    } placeholderError: { error in
                        ErrorView(error: error)
                    }
                    viewController = UIHostingController(rootView: imageView)
                }

                it("it should match recorded image") {
                    expect(viewController).toEventually(haveValidSnapshot(as: .image))
                }
            }
            
        }
    }
}
