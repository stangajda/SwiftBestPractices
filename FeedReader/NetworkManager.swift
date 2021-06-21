//
//  NetworkManager.swift
//  FeedReader
//
//  Created by Stan Gajda on 17/06/2021.
//

import Foundation
import Combine

class NetworkManager{
    
    var cancellable: AnyCancellable?
    var session: URLSession = .shared
   
    enum APIError: Error, LocalizedError {
        case unknown, apiError(error: Error)

        var errorDescription: String? {
            switch self {
            case .unknown:
                return "Unknown error"
            case .apiError(let error):
                return error.localizedDescription
            }
        }
    }

    init(session: URLSession = .shared){
        self.session = session
    }
    
    func fetchData(url: URL) -> AnyPublisher<Data, Error> {
        let request = URLRequest(url: url)

        return self.session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                if let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode {
                    return data
                }
                
                if let response = response as? HTTPURLResponse, let url = response.url{
                    let error = NSError(domain: url.absoluteString, code: response.statusCode, userInfo: nil)
                    throw error
                }
                
                throw APIError.unknown
                
            }
            .mapError { error in
//                if let error = error as? APIError {
//                    return error
//                } else {
//                    return APIError.apiError(error: error)
//                }
                error
            }
            .eraseToAnyPublisher()
    }
    
}
