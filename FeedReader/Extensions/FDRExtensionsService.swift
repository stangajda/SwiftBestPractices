//
//  ServiceHelper.swift
//  FeedReader
//
//  Created by Stan Gajda on 03/07/2021.
//

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

extension Publisher where Failure == Never {
    func assignNoRetain<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on root: Root) -> AnyCancellable {
       sink { [weak root] (value) in
            root?[keyPath: keyPath] = value
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
            throw FDRAPIError.unknownResponse
        }
        guard apiCodes.contains(code) else {
            throw FDRAPIError.apiCode(code)
        }
        return data
    }
}

extension Data {
    func toImage(_ request: URLRequest) throws -> UIImage{
        guard let image = UIImage(data: self) else {
            throw FDRAPIError.imageConversion(request)
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

typealias APICode = Int
typealias APICodes = Range<APICode>

extension APICodes {
    static let success = 200 ..< 300
}
