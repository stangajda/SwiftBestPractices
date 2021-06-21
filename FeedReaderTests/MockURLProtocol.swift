//
//  MockURLProtocol.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 18/06/2021.
//

import Foundation

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
        if let data = data {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        }
        else {
            client?.urlProtocol(self, didFailWithError: error!)
        }
        
    }
    
    override func stopLoading() {

    }
    
}
