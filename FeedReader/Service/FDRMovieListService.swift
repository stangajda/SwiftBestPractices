//
//  FDRMovieList.swift
//  FeedReader
//
//  Created by Stan Gajda on 02/08/2021.
//

import Foundation
import Combine

struct FDRMovieListService{
    let service = FDRService()
    func fetchMovies(_ request: URLRequest) -> AnyPublisher<FDRMovies, Error>{
        return self.service.fetchData(request)
    }
}
