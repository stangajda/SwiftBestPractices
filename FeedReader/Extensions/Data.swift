//
//  Data.swift
//  FeedReader
//
//  Created by Stan Gajda on 30/01/2024.
//

import UIKit

extension Data {
    func toImage(_ request: URLRequest) throws -> UIImage {
        guard let image = UIImage(data: self) else {
            throw APIError.imageConversion(request)
        }
        return image
    }
}
