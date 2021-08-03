//
//  FDRImageService.swift
//  FeedReader
//
//  Created by Stan Gajda on 02/08/2021.
//

import Foundation
import Combine
import UIKit

protocol FDRImageServiceInteface {
    func fetchImage(_ request: URLRequest) -> AnyPublisher<UIImage, Error>
}

struct FDRImageService: FDRImageServiceInteface{
    let service: FDRServiceInterface = FDRService()
    func fetchImage(_ request: URLRequest) -> AnyPublisher<UIImage, Error> {
        service.fetchData(request)
            .tryMap { data in
                try data.toImage(request)
            }
            .eraseToAnyPublisher()
    }
}
