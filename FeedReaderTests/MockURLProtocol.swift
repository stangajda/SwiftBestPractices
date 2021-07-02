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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            if let data = data {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                self.client?.urlProtocol(self, didLoad: data)
                self.client?.urlProtocolDidFinishLoading(self)
            }
            else {
                self.client?.urlProtocol(self, didFailWithError: error!)
            }
        }
    }
    
    override func stopLoading() {

    }
    
}
