//
//  FDRMovieList.swift
//  FeedReader
//
//  Created by Stan Gajda on 02/08/2021.
//

import Foundation
import Combine

protocol FDRMovieListServiceInterface {
    func fetchMovies(_ request: URLRequest) -> AnyPublisher<FDRMovies, Error>
}

struct FDRMovieListService: FDRMovieListServiceInterface{
    let service: FDRServiceInterface = FDRService()
    func fetchMovies(_ request: URLRequest) -> AnyPublisher<FDRMovies, Error>{
        return self.service.fetchData(request)
    }
}
