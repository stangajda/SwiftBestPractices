//
//  APIUrlImageBuilder.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/08/2021.
//

import Foundation

struct APIUrlImageBuilder: APIUrlImageBuilderProtocol{
    static var imageURL: URL? { URL(string: Config.API.Image.url) }
}

protocol ImagePathProtocol {
    func stringPath() -> String
}

struct OriginalPath: ImagePathProtocol{
    func stringPath() -> String{
        Config.API.Image.originalPath
    }
}

struct W200Path: ImagePathProtocol {
    func stringPath() -> String {
        Config.API.Image.w200Path
    }
}
