//
//  FDRImageService.swift
//  FeedReader
//
//  Created by Stan Gajda on 02/08/2021.
//

import Foundation
import Combine
import UIKit
import Resolver

protocol FDRImageServiceInterface {
    func fetchImage(_ request: URLRequest) -> AnyPublisher<UIImage, Error>
}

struct FDRImageService: FDRImageServiceInterface{
    @Injected var service: FDRServiceInterface
    func fetchImage(_ request: URLRequest) -> AnyPublisher<UIImage, Error> {
        service.fetchData(request)
            .tryMap { data in
                try data.toImage(request)
            }
            .eraseToAnyPublisher()
    }
}
