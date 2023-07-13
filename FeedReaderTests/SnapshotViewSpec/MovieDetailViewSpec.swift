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

class MovieDetailViewSpec: QuickSpec {
    override class func spec() {
        describe("check movie detail view to match recorded snapshot") {

            var viewController: UIViewController!

            beforeEach {
                Injection.main.mockDetailViewModel()
            }

            context("when movie detail is loaded") {
                beforeEach {
                    @Injected(name: .movieDetailStateLoaded) var viewModel: AnyMovieDetailViewModelProtocol
                    viewController = UIHostingController(rootView: MovieDetailView(viewModel))
                }

                it("it should match recorded image") {
                    expect(viewController).toEventually(haveValidSnapshot(as: .image))
                }
            }

            context("when movie detail is loading") {
                beforeEach {
                    @Injected(name: .movieDetailStateLoading) var viewModel: AnyMovieDetailViewModelProtocol
                    viewController = UIHostingController(rootView: MovieDetailView(viewModel))
                }

                it("it should match recorded image") {
                    expect(viewController).toEventually(haveValidSnapshot(as: .image))
                }
            }

            context("when movie detail is failed") {
                beforeEach {
                    @Injected(name: .movieDetailStateFailed) var viewModel: AnyMovieDetailViewModelProtocol
                    viewController = UIHostingController(rootView: MovieDetailView(viewModel))
                }

                it("it should match recorded image") {
                    expect(viewController).toEventually(haveValidSnapshot(as: .image))
                }
            }
        }
    }
}
