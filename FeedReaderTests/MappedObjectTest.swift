//
//  MappedObjectTest.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 21/06/2021.
//

import XCTest

class MappedObjectTest: ErrorResponseTests {

    func testMapObject() throws {
        let dataFromFile = load("MockResponseResult.json")

        let stubSuccesfullResponse: (data: Data, statusCode: Int) = (dataFromFile, 200)
        let expectation = self.expectation(description: "response result")
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: stubSuccesfullResponse.statusCode, httpVersion: nil, headerFields: nil)!
            return (response, stubSuccesfullResponse.data, nil)
        }
        
        cancellable = self.manager!.fetchDataAndMap(url: stubAnyUrl)
            .sink { (completion) in
                switch completion {
                    case .failure(let error):
                        print("-----\(error)")
                        XCTFail("result should not failure")
                    case .finished:
                        XCTAssert(true,"result must finish")
                }
        } receiveValue: { value in
            //XCTAssertEqual(value, Data([0,1,0,1]), "data results does not matched")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func load(_ filename: String) -> Data {
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
                fatalError("Couldn't find \(filename) in main bundle.")
        }

        do {
            return try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
    }
    
}
