//
//  MockURLProtocol.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 18/06/2021.
//

import Foundation

extension URLSession {
    static var mockURLSession: URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        configuration.timeoutIntervalForRequest = 1
        configuration.timeoutIntervalForResource = 1
        return URLSession(configuration: configuration)
    }
}

extension MockURLProtocol {
    struct MockedResponse {
        let url: URL
        let result: Result<Data, Swift.Error>
        let httpCode: HTTPCode
        let httpVersion: String
        let headers: [String: String]
        let loadingTime: TimeInterval
        let customResponse: URLResponse?
    }
}

extension MockURLProtocol.MockedResponse {
    enum Error: Swift.Error {
        case failedMockCreation
    }
    
    init<T>(
            url: URL,
            result: Result<T, Swift.Error>,
            httpCode: HTTPCode = 200,
            httpVersion: String = "HTTP/1.1",
            headers: [String: String] = ["Content-Type": "application/json"],
            loadingTime: TimeInterval = 0.1
    ) throws where T: Encodable {
        self.url = url
        switch result {
        case let .success(value):
            self.result = .success(try JSONEncoder().encode(value))
        case let .failure(error):
            self.result = .failure(error)
        }
        self.httpCode = httpCode
        self.httpVersion = httpVersion
        self.headers = headers
        self.loadingTime = loadingTime
        customResponse = nil
    }
    
    init(
        url: URL,
        result: Result<Data, Swift.Error>,
        httpCode: HTTPCode = 200,
        httpVersion: String = "HTTP/1.1",
        headers: [String: String] = ["Content-Type": "application/json"],
        loadingTime: TimeInterval = 0.1
    ) throws {
        self.url = url
        switch result {
        case let .success(value):
            self.result = .success(value)
        case let .failure(error):
            self.result = .failure(error)
        }
        self.httpCode = httpCode
        self.httpVersion = httpVersion
        self.headers = headers
        self.loadingTime = loadingTime
        customResponse = nil
    }
    
}

extension URLSession {
    static var mockedResponseConfig: URLSession {
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [MockURLProtocol.self]
        sessionConfiguration.timeoutIntervalForRequest = 1
        sessionConfiguration.timeoutIntervalForResource = 1
        return URLSession(configuration: sessionConfiguration)
    }
}

extension MockURLProtocol {
    static var mock: MockedResponse?
}

class MockURLProtocol: URLProtocol {
       
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let mock = MockURLProtocol.mock,
            let url = request.url,
            let response = mock.customResponse ??
                HTTPURLResponse(url: url,
                statusCode: mock.httpCode,
                httpVersion: mock.httpVersion,
                headerFields: mock.headers) {
            DispatchQueue.main.asyncAfter(deadline: .now() + mock.loadingTime) { [weak self] in
                guard let self = self else { return }
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                switch mock.result {
                case let .success(data):
                    self.client?.urlProtocol(self, didLoad: data)
                    self.client?.urlProtocolDidFinishLoading(self)
                case let .failure(error):
                    let failure = NSError(domain: NSURLErrorDomain, code: 1,
                                          userInfo: [NSUnderlyingErrorKey: error])
                    self.client?.urlProtocol(self, didFailWithError: failure)
                }
            }
        }
    }
    
    override func stopLoading() {

    }
    
}
