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
import PreviewSnapshotsTesting

class MovieDetailViewSpec: QuickSpec {
    override class func spec() {
        describe("check movie detail view to match recorded snapshot") {

            var viewController: UIViewController!

            context("when movie detail is loaded") {
                beforeEach {
                    viewController = MovieDetailView_Previews.snapshots.getViewController(.movieDetailStateLoaded)
                }

                it("it should match movie detail loaded image") {
                    expect(viewController).toEventually(haveValidSnapshot(as: .image))
                }
            }

            context("when movie detail is loading") {
                beforeEach {
                    viewController = MovieDetailView_Previews.snapshots.getViewController(.movieDetailStateLoading)
                }

                it("it should match movie detail loading image") {
                    expect(viewController).toEventually(haveValidSnapshot(as: .image))
                }
            }

            context("when movie detail is failed") {
                beforeEach {
                    viewController = MovieDetailView_Previews.snapshots.getViewController(.movieDetailStateFailed)
                }

                it("it should match movie detail failed image") {
                    expect(viewController).toEventually(haveValidSnapshot(as: .image))
                }
            }
        }
    }
}
