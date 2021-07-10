//
//  ServiceHelper.swift
//  FeedReader
//
//  Created by Stan Gajda on 03/07/2021.
//

import Foundation
import Combine
import UIKit

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
        let apiCodes: APICodes = .success
        guard let code = (self as? HTTPURLResponse)?.statusCode else {
            throw APIError.unknownResponse
        }
        guard apiCodes.contains(code) else {
            throw APIError.apiCode(code)
        }
        return data
    }
}

extension Data {
    func toImage(_ request: URLRequest) throws -> UIImage{
        guard let image = UIImage(data: self) else {
            throw APIError.imageConversion(request)
        }
        return image
    }
}

private extension Error {
    var underlyingError: Error? {
        let nsError = self as NSError
        return nsError.userInfo[NSUnderlyingErrorKey] as? Error
    }
}
