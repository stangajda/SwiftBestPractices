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
        case unknown, apiError(reason: String)

        var errorDescription: String? {
            switch self {
            case .unknown:
                return "Unknown error"
            case .apiError(let reason):
                return reason
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
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw APIError.unknown
                }
                return data
            }
            .mapError { error in
//                if let error = error as? APIError {
//                    return error
//                } else {
//                    return APIError.apiError(reason: error.localizedDescription)
//                }
                return error
            }
            .eraseToAnyPublisher()
    }
    
}
