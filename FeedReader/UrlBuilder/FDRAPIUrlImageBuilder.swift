//
//  FDRAPIUrlImageBuilder.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/08/2021.
//

import Foundation

struct FDRAPIUrlImageBuilder: FDRAPIUrlImageBuilderProtocol{
    static var imageURL: URL? { URL(string: FDRConfig.IMAGE_URL) }
}

protocol FDRImagePathInterface {
    func stringPath() -> String
}

struct FDROriginalPath: FDRImagePathInterface{
    func stringPath() -> String{
        "original"
    }
}

struct FDRW200Path: FDRImagePathInterface {
    func stringPath() -> String {
        "w200"
    }
}
