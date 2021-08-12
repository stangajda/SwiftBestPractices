//
//  FDRAPIUrlBuilder.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/08/2021.
//

import Foundation

struct FDRAPIUrlBuilder: FDRAPIUrlBuilderProtocol {
    static var baseURL: URL? { URL(string: FDRConfig.BASE_URL) }
    static var prefix: String { FDRConfig.PREFIX }
    static var apiKey: String { FDRConfig.API_KEY }
}

protocol FDRPathInterface {
    func stringPath() -> String
}

struct FDRTrendingPath: FDRPathInterface{
    func stringPath() -> String {
        FDRConfig.TRENDING_PATH
    }
}

struct FDRMoviePath: FDRPathInterface{
    var id: Int
    
    init(_ id: Int){
        self.id = id
    }
    
    func stringPath() -> String {
        "movie/\(String(id))"
    }
}
