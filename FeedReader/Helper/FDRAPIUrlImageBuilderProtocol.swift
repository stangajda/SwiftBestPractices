//
//  FDRAPIUrlImageBuilderProtocol.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/08/2021.
//

import Foundation

protocol FDRAPIUrlImageBuilderProtocol {
    static var imageURL: URL? { get }
}

extension FDRAPIUrlImageBuilderProtocol{
    static subscript(_ imageSizePath: FDRImagePathProtocol, _ imagePath: String) -> URL?{
        guard var url = Self.imageURL else {
            return nil
        }
        url.appendPathComponent(imageSizePath.stringPath())
        url.appendPathComponent(imagePath)
        return url
    }
}
