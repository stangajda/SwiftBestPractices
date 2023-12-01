//
//  APIUrlImageBuilderProtocol.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/08/2021.
//

import Foundation

protocol APIUrlImageBuilderProtocol {
    static var imageURL: URL { get }
}

extension APIUrlImageBuilderProtocol {
    static subscript(_ imageSizePath: ImagePathProtocol, _ imagePath: String) -> URL {
        var url = Self.imageURL
        url.appendPathComponent(imageSizePath.stringPath())
        url.appendPathComponent(imagePath)
        return url
    }
}
