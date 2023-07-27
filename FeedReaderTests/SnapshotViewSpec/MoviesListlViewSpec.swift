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

class MovieListViewSpec: QuickSpec {
    
    override class func spec() {
        describe("check movies list view to match recorded snapshot") {
                    
            var viewController: UIViewController!
            
            context("when movies list is loaded") {
                
                beforeEach {
                    viewController = MoviesListView_Previews.snapshots.getViewController(.movieListStateLoaded)
                }
                
                it("it should match movie list loaded image") {
                    expect(viewController).toEventually(haveValidSnapshot(as: .image))
                }
            }
            
            context("when movies list is started") {
                
                beforeEach {
                    viewController = MoviesListView_Previews.snapshots.getViewController(.movieListStateStart)
                }
                
                it("it should match movie list start image") {
                    expect(viewController).toEventually(haveValidSnapshot(as: .image))
                }
            }
            
            context("when movies list is loading") {
                beforeEach {
                    viewController = MoviesListView_Previews.snapshots.getViewController(.movieListStateLoading)
                }

                it("it should match movie list loading image") {
                    expect(viewController).toEventually(haveValidSnapshot(as: .image))
                }
            }
            
            context("when movies list is failed") {
                beforeEach {
                    viewController = MoviesListView_Previews.snapshots.getViewController(.movieListStateFailed)
                }

                it("it should match movie list failed image") {
                    expect(viewController).toEventually(haveValidSnapshot(as: .image))
                }
            }
            
            context("when movies list row") {
                beforeEach {
                    viewController = MovieRow_Previews.snapshots.getViewController()
                }

                it("it should match movie list row image") {
                    expect(viewController).toEventually(haveValidSnapshot(as: .image))
                }
            }
            
        }
    }
}
