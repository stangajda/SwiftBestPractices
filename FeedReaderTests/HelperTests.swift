//
//  Helper.swift
//  FeedReader
//
//  Created by Stan Gajda on 22/06/2021.
//

import Foundation
import Nimble
import UIKit

// MARK: - Result

extension Result where Success: Equatable {
    func isExpectSuccessToEqual(_ value: Success, file: String = #file, line: UInt = #line) {
        switch self {
        case let .success(resultValue):
            expect(
                file: file,
                line: line,
                resultValue
            ) == value
        case let .failure(error):
            fail(
                "Unexpected error: \(error)",
                file: file,
                line: line
            )
        }
    }

    func isExpectSuccessNotToEqual(_ value: Success, file: String = #file, line: UInt = #line) {
        switch self {
        case let .success(resultValue):
            expect(
                file: file,
                line: line,
                resultValue
            ) != value
        case let .failure(error):
            fail(
                "Unexpected error: \(error)",
                file: file,
                line: line
            )
        }
    }
    
}

extension Result where Success == Void {
    func isExpectSuccess(file: String = #file, line: UInt = #line) {
        switch self {
        case .failure(let error):
            fail("Unexpected error: \(error)", file: file, line: line)
        case .success:
            break
        }
    }
}


extension Result where Failure == Error {
    func isExpectFailedToEqual(_ message: String? = nil, file: String = #file, line: UInt = #line) {
        switch self {
        case .success(let value):
            fail("Unexpected error: \(value)", file: file, line: line)
        case .failure(let error):
            if let message = message {
                expect(file: file, line: line, error.localizedDescription) == message
            }
        }
    }
    
    func isExpectFailedToMatchError(_ apiError: APIError? = nil, file: String = #file, line: UInt = #line) {
        switch self {
        case .success(let value):
            fail("Unexpected error: \(value)", file: file, line: line)
        case .failure(let error):
            if let errorMessage = apiError?.localizedDescription {
                expect(file: file, line: line, error.localizedDescription) == errorMessage
            }
        }
    }
    
    func isExpectFailedToContain(_ message: String? = nil, file: String = #file, line: UInt = #line) {
        switch self {
        case .success(let value):
            fail("Unexpected error: \(value)", file: file, line: line)
        case .failure(let error):
            if let message = message {
                let isContain = error.localizedDescription.contains(message)
                expect(file: file, line: line, isContain).to(beTrue())
            }
        }
    }
    
    func isExpectFailed(_ message: String? = nil, file: String = #file, line: UInt = #line) {
        switch self {
        case .success(let value):
            fail("Unexpected error: \(value)", file: file, line: line)
        case .failure(let error):
            if let message = message {
                let isContain = error.localizedDescription.contains(message)
                expect(file: file, line: line, isContain).to(beTrue())
            }
        }
    }
    
    func isExpectFailureToMatchError(
        _ errorMatcher: @escaping (Error) -> Bool,
        file: String = #file,
        line: UInt = #line
    ) {
        switch self {
        case let .success(resultValue):
            fail(
                "Expected failure to match error but got success with value \(resultValue)",
                file: file,
                line: line
            )
        case let .failure(error):
            expect(file: file, line: line, errorMatcher(error)).to(beTrue())
        }
    }
}

extension Result {
    func isExpectSuccessType<T>(_ type: T,file: String = #file, line: UInt = #line) {
        switch self {
        case .failure(let error):
            fail("Unexpected error: \(error)", file: file, line: line)
        case .success(let resultValue):
            expect(resultValue).to(beAnInstanceOf(T.self))
            break
        }
    }
}

extension NSError {
    static var test: NSError {
        return NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey: "error"])
    }
    
    static func stubCode(code: APICode) -> NSError {
        return NSError(domain: "Unexpected API code:", code: code, userInfo: nil)
    }
}

extension Data {
    static var stubData: Data {
        return Data([0,1,0,1])
    }
}

extension APIError {
    func isExpectFailedToMatchError(_ apiError: APIError? = nil, file: String = #file, line: UInt = #line) {
        if let errorMessage = apiError {
            expect(file: file, line: line, self).to(equal(errorMessage))
        
        }
    }
}
