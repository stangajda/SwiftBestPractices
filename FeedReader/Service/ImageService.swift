//
//  ImageService.swift
//  FeedReader
//
//  Created by Stan Gajda on 02/08/2021.
//

import Combine
import UIKit

protocol ImageServiceProtocol {
    func fetchImage(_ request: URLRequest) -> AnyPublisher<UIImage, Error>
}

struct ImageService: ImageServiceProtocol {
    @Injected var service: ServiceProtocol
    fileprivate let queue = DispatchQueue(label: Config.QueueImage.label, qos: Config.QueueImage.qos)
    fileprivate var cancellable: AnyCancellable?

    func fetchImage(_ request: URLRequest) -> AnyPublisher<UIImage, Error> {
        return service.fetchData(request)
            .tryMap { data in
                try data.toImage(request)
            }
            .subscribe(on: queue)
            .eraseToAnyPublisher()
    }
}
