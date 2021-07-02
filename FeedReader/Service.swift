//
//  Service.swift
//  FeedReader
//
//  Created by Stan Gajda on 17/06/2021.
//

import Foundation
import Combine

struct Service{
    
    var cancellable: AnyCancellable?
    var session: URLSession = .shared

    init(session: URLSession = .shared){
        self.session = session
    }
    
    func fetchData<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
        fetchData(url: url)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchDataAndMap(url: URL) -> Publishers.Decode<AnyPublisher<Data, Error>, Movies, JSONDecoder> {
        fetchData(url: url)
            .decode(type: Movies.self, decoder: JSONDecoder())
    }
    
    func fetchData(url: URL) -> AnyPublisher<Data, Error> {
        let request = URLRequest(url: url)

        return self.session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                if let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode {
                    return data
                }
                
                if let response = response as? HTTPURLResponse, let url = response.url{
                    let error:NSError = NSError(domain: url.absoluteString, code: response.statusCode, userInfo: nil)
                    throw error
                }
                
                throw NSError(domain: "localDomain", code: 444, userInfo: nil)
                
            }
            .eraseToAnyPublisher()
    }
    
}
