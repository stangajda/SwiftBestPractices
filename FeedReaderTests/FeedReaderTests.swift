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
    var manager: Service?
    let stubError = "anyLocal"
    let stubAnyUrl = URL(string: "https://test.com")!
    
    override func setUpWithError() throws {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.protocolClasses = [MockURLProtocol.self]
        sessionConfiguration.timeoutIntervalForRequest = 1
        sessionConfiguration.timeoutIntervalForResource = 1
        let mockSession = URLSession(configuration: sessionConfiguration)
        manager = Service(session: mockSession)
    }

    override func tearDownWithError() throws {
        cancellable?.cancel()
        manager = nil
        cancellable = nil
    }
    
    func testSuccessfulResponse() throws {
        let aQueue = DispatchQueue(label: "serial")
        let stubData = Data([0,1,0,1])
        
        let stubSuccesfullResponse: (data: Data, statusCode: Int) = (stubData, 200)
        
        let expectation = self.expectation(description: "response result")
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: stubSuccesfullResponse.statusCode, httpVersion: nil, headerFields: nil)!
            return (response, stubSuccesfullResponse.data, nil)
        }
        
        cancellable = self.manager!.fetchData(url: stubAnyUrl)
            .subscribe(on: aQueue)
            .sink { (completion) in
                    switch completion {
                        case .failure(_):
                            XCTFail("result should not failure")
                        case .finished:
                            XCTAssert(true,"result must finish")
                    }
                } receiveValue: { value in
                    XCTAssertEqual(value, stubData, "data results does not matched")
                    expectation.fulfill()
                }
        
        waitForExpectations(timeout: 1, handler: nil)
        
    }
    
    func testFailure300Response() throws{
        try testFailureResponse(errorCode: 300)
    }
    
    func testFailure404Response() throws{
        try testFailureResponse(errorCode: 404)
    }
    
    func testFailureResponse(errorCode:Int) throws {
        let expectation = self.expectation(description: "response result")
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: errorCode, httpVersion: nil, headerFields: nil)!
            return (response, Data(), nil)
        }
        
        cancellable = self.manager!.fetchData(url: stubAnyUrl)
            .sink { (completion) in
                switch completion {
                    case .failure(let error):
                        XCTAssertEqual((error as NSError).code, errorCode, "error code does not match")
                    case .finished:
                        XCTFail("it should not finished")
                }
                expectation.fulfill()
        } receiveValue: { value in
            XCTFail("it should not get value")
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testUnknownResponse() throws {
        let expectation = self.expectation(description: "response result")
        let error = NSError(domain: stubError, code: -1, userInfo: nil)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: -1, httpVersion: nil, headerFields: nil)!
            return (response, nil, error)
        }
        
        cancellable = self.manager!.fetchData(url: stubAnyUrl)
            .sink { (completion) in
                switch completion {
                    case .failure(let error):
                        XCTAssertEqual((error as NSError).code, -1, "error code does not match")
                    case .finished:
                        XCTFail("it should not finished")
                }
                expectation.fulfill()
        } receiveValue: { value in
            XCTFail("it should not get value")
        }
        
        waitForExpectations(timeout: 1, handler: nil)

    }

}
