//
//  FDRMovieDetailService.swift
//  FeedReader
//
//  Created by Stan Gajda on 02/08/2021.
//

import Foundation
import Combine

protocol FDRMovieDetailServiceInterface {
    func fetchMovieDetail(_ request: URLRequest) -> AnyPublisher<FDRMovieDetail, Error>
}

struct FDRMovieDetailService: FDRMovieDetailServiceInterface{
    let service: FDRServiceInterface = FDRService()
    func fetchMovieDetail(_ request: URLRequest) -> AnyPublisher<FDRMovieDetail, Error>{
        return self.service.fetchData(request)
    }
}
