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
    
//    private var sut: RealCountriesWebRepository!
//    private var subscriptions = Set<AnyCancellable>()
//
//    typealias API = RealCountriesWebRepository.API
//    typealias Mock = RequestMocking.MockedResponse
//
//    override func setUp() {
//        subscriptions = Set<AnyCancellable>()
//        sut = RealCountriesWebRepository(session: .mockedResponsesOnly,
//                                         baseURL: "https://test.com")
//    }
    
    var cancellable: AnyCancellable?
    var mockManager: Service!
    let stubError = "anyLocal"
    let stubAnyUrl = URL(string: "https://test.com")!
    typealias Mock = MockURLProtocol.MockedResponse
    lazy var requestURL: URL = URL(string: String())!
    
    override func setUpWithError() throws {
        mockManager = Service(session: .mockedResponsesOnly)
        requestURL = try XCTUnwrap(stubAnyUrl)
    }

    override func tearDownWithError() throws {
        MockURLProtocol.removeAllMocks()
        cancellable?.cancel()
        mockManager = nil
        cancellable = nil
    }
    
    func testSuccessfulResponse() throws {
        let stubData = Data([0,1,0,1])
        let expectation = self.expectation(description: "response result")
        let requestURL = try XCTUnwrap(stubAnyUrl)
        let responseData = try XCTUnwrap(stubData)
        
        let mock = try Mock(url: requestURL, result: .success(responseData))
        MockURLProtocol.add(mock: mock)
        
        cancellable = self.mockManager.fetchData(url: stubAnyUrl)
            .sinkToResult({ result in
                result.assertSuccess(value: stubData)
                expectation.fulfill()
            })
        
        waitForExpectations(timeout: 1, handler: nil)
        
    }
    
    func testMapObject() throws {
        
        let dataFromFile = ErrorResponseTests.load("MockResponseResult.json")
        let moviesFromData: Movies = try JSONDecoder().decode(Movies.self,
                                                        from: dataFromFile)
        
        let expectation = self.expectation(description: "response result")

        let requestURL = try XCTUnwrap(stubAnyUrl)
        let responseData = try XCTUnwrap(moviesFromData)
        
        let mock = try Mock(url: requestURL, result: .success(responseData))
        MockURLProtocol.add(mock: mock)
        
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
    
    func testFailureResponse(errorCode: Int) throws {
        let expectation = self.expectation(description: "response result")
        let error = NSError(domain: stubError, code: errorCode, userInfo: nil)
        
        let requestURL = try XCTUnwrap(stubAnyUrl)
        let mock = try Mock(url: requestURL, result: .failure(error), httpCode: errorCode)
        MockURLProtocol.add(mock: mock)
        
        cancellable = self.mockManager.fetchData(url: stubAnyUrl)
            .sinkToResult({ result in
                result.assertFailure(errorCode)
                expectation.fulfill()
            })
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFailure300ResponseWithSuccess() throws{
        try testFailureResponseWithSuccess(errorCode: 300)
    }
    
    func testFailureResponseWithSuccess(errorCode: Int) throws {
        let expectation = self.expectation(description: "response result")
        
        let requestURL = try XCTUnwrap(stubAnyUrl)
        let mock = try Mock(url: requestURL, result: .success(Data()), httpCode: errorCode)
        MockURLProtocol.add(mock: mock)
        
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
