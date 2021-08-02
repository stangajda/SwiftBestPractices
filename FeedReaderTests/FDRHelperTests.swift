//
//  Helper.swift
//  FeedReader
//
//  Created by Stan Gajda on 22/06/2021.
//

import Foundation
import Nimble
import UIKit

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
    func isExpectSuccessToEqual(_ value: Success, file: StaticString = #file, line: UInt = #line) {
        switch self {
        case let .success(resultValue):
            expect(file: file, line: line, resultValue) == value
        case let .failure(error):
            fail("Unexpected error: \(error)", file: file, line: line)
        }
    }
}

extension Result {
    func isExpectSuccessType<T>(_ type: T,file: StaticString = #file, line: UInt = #line) {
        switch self {
        case let .failure(error):
            fail("Unexpected error: \(error)", file: file, line: line)
        case let .success(resultValue):
            expect(resultValue).to(beAnInstanceOf(T.self))
            break
        }
    }
    
    func isExpectFailedToEqual(_ message: String? = nil, file: StaticString = #file, line: UInt = #line) {
        switch self {
        case let .success(value):
            fail("Unexpected error: \(value)", file: file, line: line)
        case let .failure(error):
            if let message = message {
                expect(file: file, line: line, error.localizedDescription) == message
            }
        }
    }
    
    func isExpectFailedToContain(_ message: String? = nil, file: StaticString = #file, line: UInt = #line) {
        switch self {
        case let .success(value):
            fail("Unexpected error: \(value)", file: file, line: line)
        case let .failure(error):
            if let message = message {
                let isContain = error.localizedDescription.contains(message)
                expect(file: file, line: line, isContain).to(beTrue())
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
