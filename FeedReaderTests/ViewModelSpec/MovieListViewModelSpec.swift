//
//  MovieListViewModelSpec.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 08/06/2023.
//

import Foundation
import UIKit
@testable import FeedReader
import Combine
import Nimble
import Quick

class MovieListViewModelSpec: QuickSpec {

    override class func spec() {
        describe("check movie list service") {
            var viewModel: AnyMoviesListViewModelProtocol?
            var movieItem: Array<MoviesListViewModel.MovieItem>!
            var anotherMovieItem: Array<MoviesListViewModel.MovieItem>!

            beforeEach {
                Injection.main.mockService()
                @Injected var viewModelInjected: AnyMoviesListViewModelProtocol
                viewModel = viewModelInjected
            }

            afterEach {
                viewModel?.onDisappear()
                viewModel = nil
            }

            context("when send on appear action") {
                beforeEach {
                    let moviesFromData: Movies = Data.jsonDataToObject(Config.MockMovieList.movieListResponseResult)
                    let anotherMoviesFromData: Movies =
                        Data.jsonDataToObject(Config.MockMovieList.anotherMovieListResponseResult)

                    let result: Result<Movies, Error> = .success(moviesFromData)
                    @Injected(result) var service: MovieListServiceProtocol

                    movieItem = moviesFromData.results.map { movie in
                        MoviesListViewModel.MovieItem(movie)
                    }

                    anotherMovieItem = anotherMoviesFromData.results.map { movie in
                        MoviesListViewModel.MovieItem(movie)
                    }

                    viewModel?.onAppear()
                }

                it("it should match from loaded state counted objects in array") {
                    expect(viewModel?.state).toEventually(beLoadedStateMoviesCount(22))
                }

                it("it should get movies from loaded state match mapped object") {
                    expect(viewModel?.state).toEventually(equal(.loaded(movieItem)))
                }

                it("it should get movies from loaded state match not mapped object") {
                    expect(viewModel?.state).toEventuallyNot(equal(.loaded(anotherMovieItem)))
                }
            }

            context("when send on reset action make on appear and on disappear") {
                beforeEach {
                    viewModel?.onAppear()
                    viewModel?.onDisappear()
                }

                it("it should get start state") {
                    expect(viewModel?.state).toEventually(equal(.start()))
                }
            }

            context("when send on reset action make on active and on background") {
                beforeEach {
                    viewModel?.onActive()
                    viewModel?.onBackground()
                }

                it("it should get start state") {
                    expect(viewModel?.state).toEventually(equal(.start()))
                }
            }

            let errorCodes: [Int] = [300, 404, 500]
            errorCodes.forEach { errorCode in
                context("when error response with error code \(errorCode)") {
                    beforeEach {
                        let result: Result<Movies, Error> = .failure(APIError.apiCode(errorCode))
                        @Injected(result) var service: MovieListServiceProtocol
                        viewModel?.onAppear()
                    }

                    it("it should get state failed loaded with error code \(errorCode)") {
                        expect(viewModel?.state).toEventually(equal(.failedLoaded(APIError.apiCode(errorCode))))
                    }
                }
            }

            context("when error response unknown error") {
                beforeEach {
                    let result: Result<Movies, Error> = .failure(APIError.unknownResponse)
                    @Injected(result) var service: MovieListServiceProtocol
                    viewModel?.onAppear()
                }

                it("it should get state failed loaded with unknown error") {
                    expect(viewModel?.state).toEventually(equal(.failedLoaded(APIError.unknownResponse)))
                }
            }
        }
    }
}
