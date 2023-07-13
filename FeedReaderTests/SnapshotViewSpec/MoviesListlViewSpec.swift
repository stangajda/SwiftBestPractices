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

class MovieListViewSpec: QuickSpec {
    
    override class func spec() {
        describe("check movies list view to match recorded snapshot") {
                    
            var viewController: UIViewController!

            beforeEach {
                Injection.main.mockViewModel()
            }
            
            context("when movies list is loaded") {
                
                beforeEach {
                    @Injected(name: .movieListStateLoaded) var viewModel: AnyMoviesListViewModelProtocol
                    viewController = UIHostingController(rootView: MoviesListView(viewModel: viewModel))
                }

                it("it should match recorded image") {
                    expect(viewController).toEventually(haveValidSnapshot(as: .image))
                }
            }
            
            context("when movies list is loading") {
                beforeEach {
                    @Injected(name: .movieListStateLoading) var viewModel: AnyMoviesListViewModelProtocol
                    viewController = UIHostingController(rootView: MoviesListView(viewModel: viewModel))
                }

                it("it should match recorded image") {
                    expect(viewController).toEventually(haveValidSnapshot(as: .image))
                }
            }
            
            context("when movies list is failed") {
                beforeEach {
                    @Injected(name: .movieListStateFailed) var viewModel: AnyMoviesListViewModelProtocol
                    viewController = UIHostingController(rootView: MoviesListView(viewModel: viewModel))
                }

                it("it should match recorded image") {
                    expect(viewController).toEventually(haveValidSnapshot(as: .image))
                }
            }
        }
    }
}
