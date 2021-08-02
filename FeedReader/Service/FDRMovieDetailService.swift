//
//  FDRMovieDetailService.swift
//  FeedReader
//
//  Created by Stan Gajda on 02/08/2021.
//

import Foundation
import Combine

struct FDRMovieDetailService{
    let service = FDRService()
    func fetchMovieDetail(_ request: URLRequest) -> AnyPublisher<FDRMovieDetail, Error>{
        return self.service.fetchData(request)
    }
}
