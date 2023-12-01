//
//  HelperViewsSpec.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 27/07/2023.
//

import Foundation
@testable import FeedReader
import SwiftUI
import Nimble
import Quick
import SnapshotTesting
import Nimble_SnapshotTesting
import PreviewSnapshotsTesting

class HelperViewsSpec: QuickSpec {
    override class func spec() {
        describe("check helper views to match recorded snapshot") {
            var viewController: UIViewController!

            context("when error view is loaded") {
                beforeEach {
                    viewController = ErrorView_Previews.snapshots.getViewController()
                }

                it("it should match error view image") {
                    expect(viewController).toEventually(haveValidSnapshot(as: .image))
                }
            }

            context("when activity indicator view is loaded") {
                beforeEach {
                    viewController = ActivityIndicator_Previews.snapshots.getViewController()
                }

                it("it should match loading view image") {
                    expect(viewController).toEventually(haveValidSnapshot(as: .image))
                }
            }

            context("when icon value view is loaded") {
                beforeEach {
                    viewController = IconValueView_Previews.snapshots.getViewController()
                }

                it("it should match icon value view image") {
                    expect(viewController).toEventually(haveValidSnapshot(as: .image))
                }
            }

            context("when overlay text view is loaded") {
                beforeEach {
                    viewController = OverlayTextView_Previews.snapshots.getViewController()
                }

                it("it should match overlay text view image") {
                    expect(viewController).toEventually(haveValidSnapshot(as: .image))
                }
            }

            context("when stars rating view is loaded") {
                beforeEach {
                    viewController = StarsRatingView_Previews.snapshots.getViewController()
                }

                it("it should match stars rating view image") {
                    expect(viewController).toEventually(haveValidSnapshot(as: .image))
                }
            }

            context("when stars votes view is loaded") {
                beforeEach {
                    viewController = StarsVotedView_Previews.snapshots.getViewController()
                }

                it("it should match stars votes view image") {
                    expect(viewController).toEventually(haveValidSnapshot(as: .image))
                }
            }

        }
    }
}
