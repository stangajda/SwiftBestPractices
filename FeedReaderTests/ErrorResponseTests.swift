//
//  FeedReaderTests.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 16/06/2021.
//

import XCTest
@testable import FeedReader
import Combine

class ErrorResponseTests: XCTestCase {
    
    typealias Mock = MockURLProtocol.MockedResponse
    
    var cancellable: AnyCancellable?
    let stubURlString: String = "https://test.com"
    lazy var mockManager: Service = Service(session: .mockURLSession)
    lazy var stubAnyUrl: URL = URL(string: stubURlString)!
    lazy var requestURL: URL = URL(string: stubURlString)!
    
    override func setUpWithError() throws {
        stubAnyUrl = try XCTUnwrap(URL(string: stubURlString))
        requestURL = try XCTUnwrap(stubAnyUrl)
    }

    override func tearDownWithError() throws {
        MockURLProtocol.mock = nil
        cancellable?.cancel()
        cancellable = nil
    }
    
    func testSuccessfulResponse() throws {
        let expectation = self.expectation(description: "response result")
        let requestURL = try XCTUnwrap(stubAnyUrl)
        let responseData = try XCTUnwrap(Data.stubData)
        
        let result: Result<Data, Swift.Error> = .success(responseData)
        MockURLProtocol.mock = try Mock(url: requestURL, result: result)
        cancellable = self.mockManager.fetchData(url: stubAnyUrl)
            .sinkToResult({ result in
                result.assertSuccess(value: Data.stubData)
                expectation.fulfill()
            })
        
        waitForExpectations(timeout: 1, handler: nil)
        
    }
    
    func testMappedObject() throws {
        let expectation = self.expectation(description: "response result")
        let requestURL = try XCTUnwrap(stubAnyUrl)
        
        let dataFromFile = Data.load("MockResponseResult.json")
        let moviesFromData: Movies = try JSONDecoder().decode(Movies.self,
                                                        from: dataFromFile)
        let responseData = try XCTUnwrap(moviesFromData)
        
        MockURLProtocol.mock = try Mock(url: requestURL, result: .success(responseData))
        cancellable = self.mockManager.fetchMovies(url: stubAnyUrl)
            .sinkToResult({ result in
                result.assertSuccess(value: moviesFromData)
                expectation.fulfill()
            })
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFailure300Response() throws{
        try testFailureResponse(errorCode: 300)
    }
    
    func testFailure404Response() throws{
        try testFailureResponse(errorCode: 404)
    }
    
    func testFailure500Response() throws{
        try testFailureResponse(errorCode: 500)
    }
    
    func testFailureResponse(errorCode: HTTPCode) throws {
        let expectation = self.expectation(description: "response result")
        let requestURL = try XCTUnwrap(stubAnyUrl)
        
        let result: Result<Data, Error> = .failure(NSError.stubCode(code: errorCode))
        MockURLProtocol.mock = try Mock(url: requestURL, result: result, httpCode: errorCode)
        cancellable = self.mockManager.fetchData(url: stubAnyUrl)
            .sinkToResult({ result in
                result.assertFailure(errorCode)
                expectation.fulfill()
            })
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFailureResponse() throws {
        let stubErrorCode = 0
        let expectation = self.expectation(description: "response result")
        let requestURL = try XCTUnwrap(stubAnyUrl)
        
        MockURLProtocol.mock = try Mock(url: requestURL, result: .success(false), httpCode: stubErrorCode)
        cancellable = self.mockManager.fetchData(url: stubAnyUrl)
            .sinkToResult({ result in
                result.assertFailure(0)
                expectation.fulfill()
            })
        
        waitForExpectations(timeout: 1, handler: nil)
    }

}
