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
    
    func checkResponse(done: @escaping() -> Void, closure: @escaping (Result<UIImage, Swift.Error>) -> Void) -> AnyCancellable? {
        var cancellable: AnyCancellable?
        cancellable = mockManager.fetchImage(mockRequestUrl)
            .sinkToResult({ result in
                closure(result)
                done()
            })
        return cancellable
     
    }
  
    func convertImageToData(_ named:String) -> Data {
        let image = UIImage(named: named)
        guard let imageData = image?.pngData() else {
            fatalError("Error: \(String(describing: APIError.imageConversion(mockRequestUrl).errorDescription))")
        }
        return imageData
    }
    
}
