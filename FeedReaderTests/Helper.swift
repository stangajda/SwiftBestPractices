//
//  Helper.swift
//  FeedReader
//
//  Created by Stan Gajda on 22/06/2021.
//

import Foundation
import XCTest

extension Data{
    static func load(_ filename: String) -> Data {
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
                fatalError("Couldn't find \(filename) in main bundle.")
        }

        do {
            return try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
    }
}

// MARK: - Result

extension Result where Success: Equatable {
    func assertSuccess(value: Success, file: StaticString = #file, line: UInt = #line) {
        switch self {
        case let .success(resultValue):
            XCTAssertEqual(resultValue, value, file: file, line: line)
        case let .failure(error):
            XCTFail("Unexpected error: \(error)", file: file, line: line)
        }
    }
}

extension Result where Success == Void {
    func assertSuccess(file: StaticString = #file, line: UInt = #line) {
        switch self {
        case let .failure(error):
            XCTFail("Unexpected error: \(error)", file: file, line: line)
        case .success:
            break
        }
    }
}

extension Result {
    func assertFailure(_ message: String? = nil, file: StaticString = #file, line: UInt = #line) {
        switch self {
        case let .success(value):
            XCTFail("Unexpected success: \(value)", file: file, line: line)
        case let .failure(error):
            if let message = message {
                XCTAssertEqual(error.localizedDescription , message, file: file, line: line)
            }
        }
    }
    
    func assertFailureContains(_ message: String? = nil, file: StaticString = #file, line: UInt = #line) {
        switch self {
        case let .success(value):
            XCTFail("Unexpected success: \(value)", file: file, line: line)
        case let .failure(error):
            if let message = message {
                let isContain = error.localizedDescription.contains(message)
                XCTAssertTrue(isContain , message, file: file, line: line)
            }
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
