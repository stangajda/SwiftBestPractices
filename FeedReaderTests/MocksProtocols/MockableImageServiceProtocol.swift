//
//  MockableImageServiceProtocol.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 27/04/2023.
//

import Foundation
import UIKit
import Combine
import Nimble

protocol MockableImageServiceProtocol: MockableBaseServiceProtocol {
    var mockManager: ImageServiceProtocol { get }
}

extension MockableImageServiceProtocol {
    
    func fetchImage(done: @escaping() -> Void, closure: @escaping (Result<UIImage, Swift.Error>) -> Void) -> AnyCancellable? {
        var cancellable: AnyCancellable?
        cancellable = mockManager.fetchImage(mockRequestUrl)
            .sinkToResult({ result in
                closure(result)
                done()
            })
        return cancellable
     
    }
    
}
