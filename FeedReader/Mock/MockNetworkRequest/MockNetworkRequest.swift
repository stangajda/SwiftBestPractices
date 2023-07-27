//
//  MockNetworkRequest.swift
//  FeedReader
//
//  Created by Stan Gajda on 24/07/2023.
//

import Foundation

protocol NetworkResponseProtocol {
}

struct MockNetworkRequest: NetworkResponseProtocol {
    typealias Mock = MockURLProtocol.MockedResponse

    init<T:Encodable> (_ result: Result<T, Swift.Error>) {
        Self.response(result)
    }

    init(_ result: Result<Data, Swift.Error>) {
        Self.response(result)
    }
    
    static var mockRequestUrl: URLRequest {
        return URLRequest(url: MockAPIRequest[MockEmptyPath()]).get()
    }
    
    static func response<T:Encodable> (_ result: Result<T, Swift.Error>) {
        do {
            MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: result, apiCode: result.getApiCode())
        } catch {
            fatalError("Error: \(error.localizedDescription)")
        }
    }
    
    static func response(_ result: Result<Data, Swift.Error>) {
        do {
            MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: result, apiCode: result.getApiCode())
        } catch {
            fatalError("Error: \(error.localizedDescription)")
        }
    }

}
