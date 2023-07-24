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

    static func getApiCode<T>(_ result: Result<T, Swift.Error>) -> APICode {
        switch result {
        case .success(_):
            return 200
        case .failure(let error):
            if let error = error as? URLError {
                return APICode(error.errorCode)
            }
            return 0
        }
    }
    
    static var mockRequestUrl: URLRequest {
        return URLRequest(url: MockAPIRequest[MockEmptyPath()]!).get()
    }
    
    static func response<T:Encodable> (_ result: Result<T, Swift.Error>) {
        do {
            MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: result, apiCode: getApiCode(result))
        } catch {
            fatalError("Error: \(error.localizedDescription)")
        }
    }
    
    static func response(_ result: Result<Data, Swift.Error>) {
        do {
            MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: result, apiCode: getApiCode(result))
        } catch {
            fatalError("Error: \(error.localizedDescription)")
        }
    }

    static func response(_ result: Result<Bool, Swift.Error>) {
        do {
            MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: result, apiCode: getApiCode(result))
        } catch {
            fatalError("Error: \(error.localizedDescription)")
        }
    }
}
