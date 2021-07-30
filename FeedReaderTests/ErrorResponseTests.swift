//
//  FeedReaderTests.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 16/06/2021.
//

import XCTest
@testable import FeedReader
import Combine
import Resolver
import Nimble
import Quick

class ErrorResponseTests: XCTestCase {
    
    typealias Mock = MockURLProtocol.MockedResponse
    var cancellable: AnyCancellable?
    lazy var mockManager: Service = Service()
    lazy var mockRequestUrl: URLRequest = MockAPIRequest["stubPath"].get()
    
    override func setUpWithError() throws {
        Resolver.registerMockServices()
    }

    override func tearDownWithError() throws {
        MockURLProtocol.mock = nil
        cancellable?.cancel()
        cancellable = nil
    }
    
    func testSuccessfulResponse() throws {
        let responseData = Data.stubData
        
        let result: Result<Data, Swift.Error> = .success(responseData)
        MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: result)
        
        waitUntil{ [unowned self] done in
            self.cancellable = self.mockManager.fetchData(self.mockRequestUrl)
                .sinkToResult({ result in
                    result.assertSuccess(value: Data.stubData)
                    done()
                })
        }
    }
    
    func testMappedObject() throws {
        let dataFromFile = Data.load("MockResponseResult.json")
        let moviesFromData: Movies = try JSONDecoder().decode(Movies.self,
                                                        from: dataFromFile)
        
        MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: .success(moviesFromData))
        waitUntil{ [unowned self] done in
            self.cancellable = self.mockManager.fetchMovies(self.mockRequestUrl)
                .sinkToResult({ result in
                    result.assertSuccess(value: moviesFromData)
                    done()
                })
        }
    }
    
    func testImageSuccessfulConversion() throws {
        let uiImage = UIImage(named: "StubImage")
        guard let imageData = uiImage?.pngData() else {
            throw APIError.imageConversion(nil)
        }
       
        MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: .success(imageData))
        waitUntil{ [unowned self] done in
            cancellable = self.mockManager.fetchImage(mockRequestUrl)
                .sinkToResult({ result in
                    switch result{
                    case .success(_):
                        _ = succeed()
                    case .failure(_):
                        fail()
                    }
                    done()
                })
        }
    }
    
    func testImageFailureConversion() throws {
        MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: .success(Data.stubData))
        waitUntil { [unowned self] done in
            cancellable = self.mockManager.fetchImage(mockRequestUrl)
                .sinkToResult({ [unowned self] result in
                    result.assertFailure(APIError.imageConversion(mockRequestUrl).errorDescription)
                    done()
                })
        }
    }
    
    func testFailureResponses() throws {
        let errorCodes = [300,404,500]
        for errorCode in errorCodes {
            try testFailureResponse(errorCode: errorCode)
        }
    }
    
    func testFailureResponse(errorCode: APICode) throws {
        let result: Result<Data, Error> = .failure(NSError.stubCode(code: errorCode))
        MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: result, apiCode: errorCode)
        waitUntil { [unowned self] done in
            cancellable = self.mockManager.fetchData(mockRequestUrl)
                .sinkToResult({ result in
                    result.assertFailureContains(APIError.apiCode(errorCode).errorDescription)
                    done()
                })
        }
    }
    
    func testFailureResponse() throws {
        let stubErrorCode = 0
        MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: .success(false), apiCode: stubErrorCode)
        waitUntil { [unowned self] done in
            cancellable = self.mockManager.fetchData(mockRequestUrl)
                .sinkToResult({ result in
                    result.assertFailure(APIError.apiCode(0).errorDescription)
                    done()
                })
        }
    }

}
