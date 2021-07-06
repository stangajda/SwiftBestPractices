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
    var mockManager: Service!
    let stubError: String = "https://test.com"
    lazy var stubAnyUrl: URL = URL(string: String())!
    lazy var requestURL: URL = URL(string: String())!
    
    override func setUpWithError() throws {
        mockManager = Service(session: .mockedResponsesOnly)
        stubAnyUrl = try XCTUnwrap(URL(string: "https://test.com"))
        requestURL = try XCTUnwrap(stubAnyUrl)
    }

    override func tearDownWithError() throws {
        MockURLProtocol.mock = nil
        cancellable?.cancel()
        mockManager = nil
        cancellable = nil
    }
    
    func testSuccessfulResponse() throws {
        let expectation = self.expectation(description: "response result")
        let requestURL = try XCTUnwrap(stubAnyUrl)
        let responseData = try XCTUnwrap(Data.stubData)
        
        MockURLProtocol.mock = try Mock(url: requestURL, result: .success(responseData))
        cancellable = self.mockManager.fetchData(url: stubAnyUrl)
            .sinkToResult({ result in
                result.assertSuccess(value: Data.stubData)
                expectation.fulfill()
            })
        
        waitForExpectations(timeout: 1, handler: nil)
        
    }
    
    func testMappedObject() throws {
        
        let dataFromFile = ErrorResponseTests.load("MockResponseResult.json")
        let moviesFromData: Movies = try JSONDecoder().decode(Movies.self,
                                                        from: dataFromFile)
        
        let expectation = self.expectation(description: "response result")

        let requestURL = try XCTUnwrap(stubAnyUrl)
        let responseData = try XCTUnwrap(moviesFromData)
        
        MockURLProtocol.mock = try Mock(url: requestURL, result: .success(responseData))
        cancellable = self.load(url: stubAnyUrl)
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
        
        MockURLProtocol.mock = try Mock(url: requestURL, result: .failure(NSError.stubCode(code: errorCode)), httpCode: errorCode)
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
    
    func load(url: URL) -> AnyPublisher<Movies, Error>{
        return self.mockManager.fetchData(url)
    }

}
