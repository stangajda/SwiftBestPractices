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

extension URLResponse{
    func mapError(_ data: Data) throws -> Data{
        let httpCodes: HTTPCodes = .success
        guard let code = (self as? HTTPURLResponse)?.statusCode else {
            throw APIError.unexpectedResponse
        }
        guard httpCodes.contains(code) else {
            throw APIError.httpCode(code)
        }
        return data
    }
}

private extension Error {
    var underlyingError: Error? {
        let nsError = self as NSError
        if nsError.domain == NSURLErrorDomain && nsError.code == -1009 {
            return self
        }
        return nsError.userInfo[NSUnderlyingErrorKey] as? Error
    }
}
