//
//  FDRAPIUrlBuilder.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/08/2021.
//

import Foundation

struct FDRAPIUrlBuilder: FDRAPIUrlBuilderProtocol {
    static var baseURL: URL? { URL(string: BASE_URL) }
    static var prefix: String { PREFIX }
    static var apiKey: String { API_KEY }
}

protocol FDRPathInterface {
    func stringPath() -> String
}

struct FDRTrendingPath: FDRPathInterface{
    func stringPath() -> String {
        TRENDING_PATH
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
