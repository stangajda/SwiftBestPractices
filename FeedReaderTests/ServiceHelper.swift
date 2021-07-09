//
//  ServiceHelper.swift
//  FeedReader
//
//  Created by Stan Gajda on 03/07/2021.
//

import Foundation
import Combine

extension Publisher {
    func sinkToResult(_ result: @escaping (Result<Output, Failure>) -> Void) -> AnyCancellable {
        return sink(receiveCompletion: { completion in
            switch completion {
            case let .failure(error):
                result(.failure(error))
            default: break
            }
        }, receiveValue: { value in
            result(.success(value))
        })
    }
    
    func mapUnderlyingError() -> Publishers.MapError<Self, Failure> {
        mapError { error in
            (error.underlyingError as? Failure) ?? error
        }
    }
}

extension URLRequest {
    func get() -> URLRequest {
        var copy = self
        copy.httpMethod = "GET"
        return copy
    }
}

extension URLResponse {
    func mapError(_ data: Data) throws -> Data{
        let httpCodes: HTTPCodes = .success
        guard let code = (self as? HTTPURLResponse)?.statusCode else {
            throw APIError.unexpectedResponse
        }
        guard httpCodes.contains(code) else {
            throw APIError.apiCode(code)
        }
        return data
    }
}

private extension Error {
    var underlyingError: Error? {
        let nsError = self as NSError
        return nsError.userInfo[NSUnderlyingErrorKey] as? Error
    }
}
