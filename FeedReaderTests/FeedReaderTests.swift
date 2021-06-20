//
//  FeedReaderTests.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 16/06/2021.
//

import XCTest
@testable import FeedReader
import Combine

class FeedReaderTests: XCTestCase {
    var cancellable: AnyCancellable?
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }
    
    func testSuccessfulResponse() throws {
        let stubAnyUrl = URL(string: "http://anyURL.com")!
        let stubSuccesfullResponse: (data: Data, statusCode: Int) = (Data([0,1,0,1]), 200)
        
        var outputResult: (isFinished:Bool, data:Data?) = (false, nil)
        let expectation = self.expectation(description: "response result")
        
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession(configuration: sessionConfiguration)

        let manager = NetworkManager(session: mockSession)
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: stubAnyUrl, statusCode: stubSuccesfullResponse.statusCode, httpVersion: nil, headerFields: nil)!
            return (response, stubSuccesfullResponse.data)
        }
        
        
        cancellable = manager.fetchData(url: stubAnyUrl)
            .sink { (completion) in
                switch completion {
                    case .failure(_):
                        outputResult.isFinished = false
                    case .finished:
                        outputResult.isFinished = true
                }
                
        } receiveValue: { value in
            outputResult.data = value
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(outputResult.isFinished, "succesful result suppose to finish")
        XCTAssertEqual(outputResult.data, Data([0,1,0,1]), "data results does not matched")
    }
    
    func testFailureResponse() throws {
        let stubAnyUrl = URL(string: "anyURL")!
        
        
        var outputResult: (isFinished:Bool, data:Data?) = (false, nil)
        let expectation = self.expectation(description: "response result")
        
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession(configuration: sessionConfiguration)

        let manager = NetworkManager(session: mockSession)
        
        let userInfo: [String : Any] =
                    [
                        NSLocalizedDescriptionKey :  NSLocalizedString("Unauthorized", value: "Please activate your account", comment: "") ,
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("Unauthorized", value: "Account not activated", comment: "")
                ]
        
        MockURLProtocol.errorRequest = NSError(domain: "com.example.error", code: 500, userInfo: userInfo)
//        MockURLProtocol.requestHandler = { request in
//            let response = HTTPURLResponse(url: stubAnyUrl, statusCode: 300, httpVersion: nil, headerFields: nil)!
//            return (response, Data())
//        }
        
        
        cancellable = manager.fetchData(url: stubAnyUrl)
            .sink { (completion) in
                switch completion {
                    case .failure(let error):
                        outputResult.isFinished = false
                        print("-----\((error as NSError).code)----")
                    case .finished:
                        outputResult.isFinished = true
                }
                expectation.fulfill()
        } receiveValue: { value in
            outputResult.data = value
            
        }
        
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertFalse(outputResult.isFinished, "succesful result suppose to finish")
//        XCTAssertEqual(outputResult.data, Data([0,1,0,1]), "data results does not matched")

    }
    
    func testUnexpectedResponse() throws {
//        let session: MockURLSession = MockURLSession()
//        let manager = NetworkManager(session: session)
//
//        let url: URL = URL(string: "anyURL")!
//
//        let loadData = manager.loadData(from: url)
//        _ = loadData.sink { (completion) in
//            let isFinished: Bool
//            var responseError: NSError?
//            switch completion {
//                case .failure(let error):
//                    responseError = error as NSError
//                    isFinished = false
//                case .finished:
//                    isFinished = true
//            }
//            XCTAssertEqual(responseError!.code, 306, "")
//            XCTAssertFalse(isFinished, "succesful result suppose to finish")
//        } receiveValue: { data in
//            XCTAssertNil(data, "received data should not be nil")
//        }

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
