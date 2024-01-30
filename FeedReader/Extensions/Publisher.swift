//
//  Publisher.swift
//  FeedReader
//
//  Created by Stan Gajda on 30/01/2024.
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
    func assignNoRetain<Root: AnyObject>(
        to keyPath: ReferenceWritableKeyPath<Root, Output>,
        on root: Root
        ) -> AnyCancellable {
        sink { [weak root] (value) in
            root?[keyPath: keyPath] = value
        }
    }
}

private extension Error {
    var underlyingError: Error? {
        let nsError = self as NSError
        return nsError.userInfo[NSUnderlyingErrorKey] as? Error
    }
}
