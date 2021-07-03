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
    var cancellable: AnyCancellable?
    var mockManager: Service?
    let stubError = "anyLocal"
    let stubAnyUrl = URL(string: "https://test.com")!
    
    override func setUpWithError() throws {
        let mockSession = URLSession.mockedResponseConfig
        mockManager = Service(session: mockSession)
    }

    override func tearDownWithError() throws {
        cancellable?.cancel()
        mockManager = nil
        cancellable = nil
    }
    
    func testSuccessfulResponse() throws {
        let stubData = Data([0,1,0,1])
        
        let stubSuccesfullResponse: (data: Data, statusCode: Int) = (stubData, 200)
        
        let expectation = self.expectation(description: "response result")
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: stubSuccesfullResponse.statusCode, httpVersion: nil, headerFields: nil)!
            return (response, stubSuccesfullResponse.data, nil)
        }
        
        cancellable = self.mockManager!.fetchData(url: stubAnyUrl)
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

        let stubSuccesfullResponse: (data: Data, statusCode: Int) = (dataFromFile, 200)
        let expectation = self.expectation(description: "response result")
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: stubSuccesfullResponse.statusCode, httpVersion: "HTTP/1.1", headerFields: ["Content-Type": "application/json"])!
            return (response, stubSuccesfullResponse.data, nil)
        }
        
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
    
    func testFailureResponse(errorCode: Int) throws {
        let expectation = self.expectation(description: "response result")
        let error = NSError(domain: stubError, code: errorCode, userInfo: nil)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: errorCode, httpVersion: nil, headerFields: nil)!
            return (response, nil, error)
        }
        
        cancellable = self.mockManager!.fetchData(url: stubAnyUrl)
            .sinkToResult({ result in
                result.assertFailure(errorCode)
                expectation.fulfill()
            })
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func load(url: URL) -> AnyPublisher<Movies, Error>{
        return self.mockManager!.fetchData(url)
    }

}
