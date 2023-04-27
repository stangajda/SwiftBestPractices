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
    
    func mockResponse(result: Result<Data, Swift.Error>, apiCode: APICode = 200) {
        do {
            MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: result, apiCode: apiCode)
        } catch {
            fatalError("Error: \(error.localizedDescription)")
        }
    }
    
    func checkResponse(closure: @escaping (Result<UIImage, Swift.Error>) -> Void) async -> AnyCancellable? {
        var cancellable: AnyCancellable?
        await waitUntil{ [self] done in
            cancellable = mockManager.fetchImage(mockRequestUrl)
                .sinkToResult({ result in
                    closure(result)
                    done()
                })
        }
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
