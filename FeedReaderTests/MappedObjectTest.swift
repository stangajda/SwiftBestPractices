//
//  MappedObjectTest.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 21/06/2021.
//

import XCTest
import Combine

class MappedObjectTest: ErrorResponseTests {

    func testMapObject() throws {
        
        let dataFromFile = MappedObjectTest.load("MockResponseResult.json")
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
    
    func load(url: URL) -> AnyPublisher<Movies, Error>{
        return self.mockManager!.fetchData(url)
    }
    
}
