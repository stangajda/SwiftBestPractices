//
//  FDRAPIUrlImageBuilder.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/08/2021.
//

import Foundation

struct FDRAPIUrlImageBuilder: FDRAPIUrlImageBuilderProtocol{
    static var imageURL: URL? { URL(string: API_IMAGE_URL) }
}

protocol FDRImagePathInterface {
    func stringPath() -> String
}

struct FDROriginalPath: FDRImagePathInterface{
    func stringPath() -> String{
        API_IMAGE_ORIGINAL_PATH
    }
}

struct FDRW200Path: FDRImagePathInterface {
    func stringPath() -> String {
        API_IMAGE_W200_PATH
    }
}
