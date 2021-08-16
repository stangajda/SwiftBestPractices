//
//  APIUrlImageBuilderProtocol.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/08/2021.
//

import Foundation

protocol APIUrlImageBuilderProtocol {
    static var imageURL: URL? { get }
}

extension APIUrlImageBuilderProtocol{
    static subscript(_ imageSizePath: ImagePathInterface, _ imagePath: String) -> URL?{
        guard var url = Self.imageURL else {
            return nil
        }
        url.appendPathComponent(imageSizePath.stringPath())
        url.appendPathComponent(imagePath)
        return url
    }
}
