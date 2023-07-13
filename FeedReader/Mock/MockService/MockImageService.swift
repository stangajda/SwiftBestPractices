//
//  MockImageService.swift
//  FeedReader
//
//  Created by Stan Gajda on 13/07/2023.
//

import Foundation
import Combine
import UIKit

struct MockImageService: ImageServiceProtocol {
    fileprivate static var result: Result<UIImage, Error> = .success(UIImage())
    
    static func mockResult(_ result: Result<UIImage, Error>) {
        Self.result = result
    }
    
    func fetchImage(_ request: URLRequest) -> AnyPublisher<UIImage, Error> {
        return Self.result.publisher.eraseToAnyPublisher()
    }
}
