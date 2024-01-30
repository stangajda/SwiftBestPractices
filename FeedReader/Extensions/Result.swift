//
//  Result.swift
//  FeedReader
//
//  Created by Stan Gajda on 30/01/2024.
//

import Combine
import UIKit

extension Result where Success: Encodable {
    func getApiCode() -> APICode {
        switch self {
        case .success:
            return APICode(200)
        case .failure(let error):
            if let error = error as? URLError {
                return APICode(error.errorCode)
            }
            return APICode(0)
        }
    }
}

typealias APICode = Int
typealias APICodes = Range<APICode>

extension APICodes {
    static let success = 200 ..< 300
}
