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
    lazy var mockManager: Service = Service(session: .mockURLSession)
    lazy var mockRequestUrl: URLRequest = MockAPIRequest["stubPath"].get()
    
    override func setUpWithError() throws {
        mockRequestUrl = try XCTUnwrap(mockRequestUrl)
    }

    override func tearDownWithError() throws {
        MockURLProtocol.mock = nil
        cancellable?.cancel()
        cancellable = nil
    }
    
    func testSuccessfulResponse() throws {
        let expectation = self.expectation(description: "response result")
        let responseData = try XCTUnwrap(Data.stubData)
        
        let result: Result<Data, Swift.Error> = .success(responseData)
        MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: result)
        cancellable = self.mockManager.fetchData(mockRequestUrl)
            .sinkToResult({ result in
                result.assertSuccess(value: Data.stubData)
                expectation.fulfill()
            })
        
        waitForExpectations(timeout: 1, handler: nil)
        
    }
    
    func testMappedObject() throws {
        let expectation = self.expectation(description: "response result")
        
        let dataFromFile = Data.load("MockResponseResult.json")
        let moviesFromData: Movies = try JSONDecoder().decode(Movies.self,
                                                        from: dataFromFile)
        let responseData: Movies = try XCTUnwrap(moviesFromData)
        
        MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: .success(responseData))
        cancellable = self.mockManager.fetchMovies(mockRequestUrl)
            .sinkToResult({ result in
                result.assertSuccess(value: moviesFromData)
                expectation.fulfill()
            })
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testImageSuccessfulConversion() throws {
        let expectation = self.expectation(description: "response result")
        
        let uiImage = UIImage(named: "StubImage")
        let imageData = uiImage?.pngData()
        let responseData: Data = try XCTUnwrap(imageData)
        
        MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: .success(responseData))
        cancellable = self.mockManager.fetchImage(mockRequestUrl)
            .sinkToResult({ result in
                switch result{
                case .success(_):
                    XCTAssert(true)
                case .failure(_):
                    XCTFail()
                }
                expectation.fulfill()
            })
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testImageFailureConversion() throws {
        let expectation = self.expectation(description: "response result")
        let responseData: Data = try XCTUnwrap(Data.stubData)
        
        MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: .success(responseData))
        cancellable = self.mockManager.fetchImage(mockRequestUrl)
            .sinkToResult({ [self] result in
                result.assertFailure(APIError.imageConversion(mockRequestUrl).errorDescription)
                expectation.fulfill()
            })
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFailureResponses() throws {
        let errorCodes = [300,404,500]
        for errorCode in errorCodes {
            try testFailureResponse(errorCode: errorCode)
        }
    }
    
    func testFailureResponse(errorCode: APICode) throws {
        let expectation = self.expectation(description: "response result")
        
        let result: Result<Data, Error> = .failure(NSError.stubCode(code: errorCode))
        MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: result, apiCode: errorCode)
        cancellable = self.mockManager.fetchData(mockRequestUrl)
            .sinkToResult({ result in
                result.assertFailureContains(APIError.apiCode(errorCode).errorDescription)
                expectation.fulfill()
            })
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFailureResponse() throws {
        let stubErrorCode = 0
        let expectation = self.expectation(description: "response result")
        
        MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: .success(false), apiCode: stubErrorCode)
        cancellable = self.mockManager.fetchData(mockRequestUrl)
            .sinkToResult({ result in
                result.assertFailure(APIError.apiCode(0).errorDescription)
                expectation.fulfill()
            })
        
        waitForExpectations(timeout: 1, handler: nil)
    }

}
