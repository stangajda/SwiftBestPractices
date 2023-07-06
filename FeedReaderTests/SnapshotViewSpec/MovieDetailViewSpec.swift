//
//  MovieDetailViewSpec.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 06/07/2023.
//

import XCTest
import Foundation
@testable import FeedReader
import SwiftUI
import Nimble
import Quick
import SnapshotTesting

class MovieDetailViewTests: XCTestCase {

    var viewController: UIViewController!

    override func setUpWithError() throws {
      try super.setUpWithError()
      let viewModelLoaded = MockMovieDetailViewModel(MoviesListViewModel.MovieItem.mock).eraseToAnyViewModelProtocol()
      let movieDetailView = MovieDetailView(viewModelLoaded)
      viewController = UIHostingController(rootView: movieDetailView)
    }

    func testMovieDetailView() throws {
      assertSnapshot(matching: viewController, as: .image(on: .iPhone13))
    }
}

//class MovieDetailViewSpec: QuickSpec {
//
//    required init() {
//        //Injection.main.setupPreviewModeDetail()
//    }
//
//    override func spec() {
//        describe("describe") {
//            //Injection.main.setupPreviewModeDetail()
//            let viewModelLoaded: AnyMovieDetailViewModelProtocol = MockMovieDetailViewModel(MoviesListViewModel.MovieItem.mock).eraseToAnyViewModelProtocol() as AnyMovieDetailViewModelProtocol
//            let movieDetailView = MovieDetailView(viewModelLoaded)
//            let view: UIView = UIHostingController(rootView: movieDetailView).view
//
//            beforeEach {
//
//            }
//
//            afterEach {
//
//            }
//
//            context("context") {
//                beforeEach {
//
//                }
//
//                it("it 1") {
//
//                    await assertSnapshot(matching: view, as: .image(size: view.intrinsicContentSize))
//
//                }
//
//                it("it 2") {
//
//                }
//            }
//        }
//    }
//}
