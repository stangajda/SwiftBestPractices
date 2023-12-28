//
//  APIUrlImageBuilder.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/08/2021.
//

import Foundation

struct APIUrlImageBuilder: APIUrlImageBuilderProtocol {
    static var imageURL: URL { URL(string: Config.APIImage.url) ?? URL(fileURLWithPath: String()) }
}

protocol ImagePathProtocol {
    func stringPath() -> String
}

struct OriginalPath: ImagePathProtocol {
    func stringPath() -> String {
        Config.APIImage.originalPath
    }
}

struct W200Path: ImagePathProtocol {
    func stringPath() -> String {
        Config.APIImage.w200Path
    }
}
