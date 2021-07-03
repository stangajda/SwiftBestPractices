//
//  MockURLProtocol.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 18/06/2021.
//

import Foundation

extension MockURLProtocol {
    struct MockedResponse {
        let url: URL
        let result: Result<Data, Swift.Error>
        let httpCode: HTTPCode
        let headers: [String: String]
        let loadingTime: TimeInterval
        let customResponse: URLResponse?
    }
}

extension MockURLProtocol.MockedResponse {
    enum Error: Swift.Error {
        case failedMockCreation
    }
    
    init<T>(apiCall: APICall, baseURL: String,
            result: Result<T, Swift.Error>,
            httpCode: HTTPCode = 200,
            headers: [String: String] = ["Content-Type": "application/json"],
            loadingTime: TimeInterval = 0.1
    ) throws where T: Encodable {
        guard let url = try apiCall.urlRequest(baseURL: baseURL).url
            else { throw Error.failedMockCreation }
        self.url = url
        switch result {
        case let .success(value):
            self.result = .success(try JSONEncoder().encode(value))
        case let .failure(error):
            self.result = .failure(error)
        }
        self.httpCode = httpCode
        self.headers = headers
        self.loadingTime = loadingTime
        customResponse = nil
    }
    
    init(apiCall: APICall, baseURL: String, customResponse: URLResponse) throws {
        guard let url = try apiCall.urlRequest(baseURL: baseURL).url
            else { throw Error.failedMockCreation }
        self.url = url
        result = .success(Data())
        httpCode = 200
        headers = [String: String]()
        loadingTime = 0
        self.customResponse = customResponse
    }
    
    init(url: URL, result: Result<Data, Swift.Error>) {
        self.url = url
        self.result = result
        httpCode = 200
        headers = [String: String]()
        loadingTime = 0
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
    static private var mocks: [MockedResponse] = []
    
    static func add(mock: MockedResponse) {
        mocks.append(mock)
    }
    
    static func removeAllMocks() {
        mocks.removeAll()
    }
    
    static private func mock(for request: URLRequest) -> MockedResponse? {
        return mocks.first { $0.url == request.url }
    }
}

class MockURLProtocol: URLProtocol {
       
    static var requestHandler: ((URLRequest) -> (HTTPURLResponse, Data?, Error?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        
        guard let handler = MockURLProtocol.requestHandler else {
            return
        }
        
        let (response, data, error) = handler(request)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            if let data = data {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                self.client?.urlProtocol(self, didLoad: data)
                self.client?.urlProtocolDidFinishLoading(self)
            }
            else {
                let failure = NSError(domain: NSURLErrorDomain, code: 1,
                                      userInfo: [NSUnderlyingErrorKey: error!])
                self.client?.urlProtocol(self, didFailWithError: failure)
            }
        }
    }
    
    override func stopLoading() {

    }
    
}
