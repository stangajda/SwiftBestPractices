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

class MovieDetailViewModelSpec: QuickSpec {
    
    override class func spec() {
        describe("check movie list service"){
            var viewModel: AnyMovieDetailViewModelProtocol?
            
            var movieItem: MovieDetailViewModel.MovieDetailItem!
            var anotherMovieItem: MovieDetailViewModel.MovieDetailItem!

            beforeEach {
                Injection.main.mockService()
                @Injected(MoviesListViewModel.MovieItem.mock) var viewModelInjected: AnyMovieDetailViewModelProtocol
                viewModel = viewModelInjected
            }
            
            afterEach {
                viewModel?.onDisappear()
                viewModel = nil
                MovieDetailViewModel.deallocateCurrentInstances()
            }

            context("when send on appear action") {
                beforeEach {
                    let moviesFromData: MovieDetail = Data.jsonDataToObject(Config.Mock.MovieDetail.movieDetailResponseResult)
                    let anotherMoviesFromData: MovieDetail = Data.jsonDataToObject(Config.Mock.MovieDetail.anotherMovieDetailResponseResult)
                    let result: Result<MovieDetail, Error> = .success(moviesFromData)
                    @Injected(result) var service: MovieDetailServiceProtocol
                    movieItem = MovieDetailViewModel.MovieDetailItem(moviesFromData)
                    anotherMovieItem = MovieDetailViewModel.MovieDetailItem(anotherMoviesFromData)
                    viewModel?.onAppear()
                }
                
                it("it should get movies from loaded state match mapped object"){
                    expect(viewModel?.state).toEventually(equal(.loaded(movieItem)))
                }
                
                it("it should get movies from loaded state match not mapped object"){
                    expect(viewModel?.state).toEventuallyNot(equal(.loaded(anotherMovieItem)))
                }
            }
            
            context("when send on reset action") {
                beforeEach {
                    viewModel?.onAppear()
                    viewModel?.onDisappear()
                }
                
                it("it should get start state"){
                    expect(viewModel?.state).toEventually(equal(.start(497698)))
                }
            }
            
            let errorCodes: Array<Int> = [300,404,500]
            errorCodes.forEach { errorCode in
                context("when error response with error code \(errorCode)") {
                    beforeEach {
                        let result: Result<MovieDetail, Error> = .failure(APIError.apiCode(errorCode))
                        @Injected(result) var service: MovieDetailServiceProtocol
                        viewModel?.onAppear()
                    }
                    
                    it("it should get state failed loaded with error code \(errorCode)"){
                        expect(viewModel?.state).toEventually(equal(.failedLoaded(APIError.apiCode(errorCode))))
                    }
                }
            }
            
            context("when error response unknown error") {
                beforeEach {
                    let result: Result<MovieDetail, Error> = .failure(APIError.unknownResponse)
                    @Injected(result) var service: MovieDetailServiceProtocol
                    viewModel?.onAppear()
                }
                
                it("it should get state failed loaded with unknown error"){
                    expect(viewModel?.state).toEventually(equal(.failedLoaded(APIError.unknownResponse)))
                }
            }
            
            context("when 1 instance exist") {
                beforeEach {
                    let result: Result<MovieDetail, Error> = .failure(APIError.unknownResponse)
                    @Injected(result) var service: MovieDetailServiceProtocol
                    viewModel?.onAppear()
                }
                
                it("it should get MovieDetailViewModel instances count 1"){
                    expect(MovieDetailViewModel.instances.count).to(equal(1))
                }
            }
            
            context("when allocate another instance") {
                beforeEach {
                    @Injected(MoviesListViewModel.MovieItem.mock) var viewModelInjected: AnyMovieDetailViewModelProtocol
                    _ = MovieDetailViewModel.instance(MoviesListViewModel.MovieItem.mock)
                }
                
                it("it should get MovieDetailViewModel instances count 1"){
                    expect(MovieDetailViewModel.instances.count).to(equal(1))
                }
            }
            
            context("when deaalocate MovieDetailViewModel instances") {
                beforeEach {
                    let result: Result<MovieDetail, Error> = .failure(APIError.unknownResponse)
                    @Injected(result) var service: MovieDetailServiceProtocol
                    viewModel?.onAppear()
                    MovieDetailViewModel.deallocateCurrentInstances()
                }
                
                it("it should get MovieDetailViewModel instances count 0"){
                    expect(MovieDetailViewModel.instances.count).to(equal(0))
                }
            }
            
        }
    }
}
