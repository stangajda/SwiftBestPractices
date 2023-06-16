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

class MovieListViewModelSpec: QuickSpec, MockableMovieListViewModelProtocol {
    @LazyInjected var mockManager: MovieListServiceProtocol
    lazy var cancellable: AnyCancellable? = nil
    lazy var mockRequestUrl: URLRequest = URLRequest(url: MockAPIRequest[MockEmptyPath()]!).get()
    lazy var viewModel: (any MoviesListViewModelProtocol)? = nil
    
    typealias Mock = MockURLProtocol.MockedResponse
    
    var movieItem: Array<MoviesListViewModel.MovieItem>!
    var anotherMovieItem: Array<MoviesListViewModel.MovieItem>!
    
    override func spec() {
        describe("check movie list service"){

            beforeEach { [self] in
                let moviesFromData: Movies = Data.jsonDataToObject("MockMovieListResponseResult.json")
                let anotherMoviesFromData: Movies = Data.jsonDataToObject("MockAnotherMovieListResponseResult.json")
                mockResponse(result: .success(moviesFromData) as Result<Movies, Swift.Error>)
                
                movieItem = moviesFromData.results.map { movie in
                    MoviesListViewModel.MovieItem(movie)
                }
                
                anotherMovieItem = anotherMoviesFromData.results.map { movie in
                    MoviesListViewModel.MovieItem(movie)
                }
                
                viewModel = MoviesListViewModel()
            
            }
            
            afterEach { [unowned self] in
                MockURLProtocol.mock = nil
                cancellable?.cancel()
                cancellable = nil
                viewModel = nil
            }

            context("when send on appear action") {
                beforeEach { [self] in
                    viewModel?.send(action: .onAppear)
                }
                
                it("it should match from loaded state counted objects in array"){ [unowned self] in

                    await waitUntil { [self] done in
                        cancellable = self.getMoviesFromLoadedState(done: done) { movies in
                            expect(movies.count).to(equal(22))
                        }
                    }
                
                }
                
                it("it should get movies from loaded state match mapped object"){ [unowned self] in
                   
                    await waitUntil{[self] done in
                        cancellable = self.getMoviesFromLoadedState(done: done) { [self] movies in
                            expect(movies).to(equal(movieItem))
                        }
                    }
                
                }
                
                it("it should get movies from loaded state match not mapped object"){ [unowned self] in
                   
                    await waitUntil{[self] done in
                        cancellable = self.getMoviesFromLoadedState(done: done) { [self] movies in
                            expect(movies).notTo(equal(anotherMovieItem))
                        }
                    }
                
                }
            }
            
            context("when send on reset action") {
                beforeEach { [self] in
                    viewModel?.send(action: .onReset)
                }
                
                it("it should get start state"){ [unowned self] in
                    
                    await waitUntil { [self] done in
                        cancellable = viewModel?.statePublisher.sink { state in
                            expect(state).to(equal(.start()))
                            done()
                        }
                    }
                    
                }
            }
            
            let errorCodes: Array<Int> = [300,404,500]
            errorCodes.forEach { errorCode in
                context("when error response with error code \(errorCode)") {
                    beforeEach { [self] in
                        viewModel?.send(action: .onReset)
                        mockResponse(result: .failure(APIError.apiCode(errorCode)) as Result<Movies, Swift.Error>)
                        viewModel?.send(action: .onAppear)
                    }
                    
                    it("it should get state failed loaded with error code \(errorCode)"){ [unowned self] in
                        
                        await waitUntil { [self] done in
                            cancellable = self.getErrorFromFailedLoadedState(done: done) { error in
                                error.isExpectFailedToMatchError(APIError.apiCode(errorCode))
                            }
                        }
                        
                    }
                }
            }
            
            context("when error response unknown error") {
                beforeEach { [self] in
                    viewModel?.send(action: .onReset)
                    mockResponse(result: .failure(APIError.unknownResponse))
                    viewModel?.send(action: .onAppear)
                }
                
                it("it should get state failed loaded with unknown error"){ [unowned self] in
                    await waitUntil{ [unowned self] done in
                        cancellable = self.getErrorFromFailedLoadedState(done: done){ error in
                            error.isExpectFailedToMatchError(APIError.unknownResponse)
                        }
                    }
                }
            }
        }
    }
}

