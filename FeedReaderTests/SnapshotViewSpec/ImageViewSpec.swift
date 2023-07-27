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
                    viewController = ImageView_Previews.snapshots.getViewController()
                }

                it("it should match movie list image") {
                    expect(viewController).toEventually(haveValidSnapshot(as: .image))
                }
            }
            
            context("when image is in preview mode detail") {
                beforeEach {
                    viewController = ImageView_Previews_MovieDetail.snapshots.getViewController()
                }

                it("it should match movie detail image") {
                    expect(viewController).toEventually(haveValidSnapshot(as: .image))
                }
            }
            
            context("when image is in preview mode failed") {
                beforeEach {
                    viewController = ImageView_Previews_Failed.snapshots.getViewController()
                }

                it("it should match movie detail image") {
                    expect(viewController).toEventually(haveValidSnapshot(as: .image))
                }
            }
            
        }
    }
}
