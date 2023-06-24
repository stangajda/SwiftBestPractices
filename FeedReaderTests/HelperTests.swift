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

    func isExpectFailedToMatchError(_ apiError: APIError? = nil, file: String = #file, line: UInt = #line) {
        switch self {
        case .success(let value):
            fail("Unexpected error: \(value)", file: file, line: line)
        case .failure(let error):
            if let errorMessage = apiError?.localizedDescription {
                expect(file: file, line: line, error.localizedDescription).to(equal(errorMessage))
            }
        }
    }
    
    func isExpectFailedToNotMatchError(_ apiError: APIError? = nil, file: String = #file, line: UInt = #line) {
        switch self {
        case .success(let value):
            fail("Unexpected error: \(value)", file: file, line: line)
        case .failure(let error):
            if let errorMessage = apiError?.localizedDescription {
                expect(file: file, line: line, error.localizedDescription).toNot(equal(errorMessage))
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

func beSuccessAndEqual(_ expected: Data) -> Predicate<Result<Data, Error>>  {
    beSuccess{
        value in
        expect(value).to(equal(expected))
    }
}

func beSuccessAndEqual<T:Equatable>(_ expected: T) -> Predicate<Result<T, Error>>  {
    beSuccess{
        value in
        expect(value).to(equal(expected))
    }
}

func beSuccessAndNotEqual<T:Equatable>(_ expected: T) -> Predicate<Result<T, Error>>  {
    beSuccess{
        value in
        expect(value).toNot(equal(expected))
    }
}

func beFailureAndMatchError(_ expected: APIError) -> Predicate<Result<Data, Error>>  {
    beFailure{
        error in
        expect(error.localizedDescription).to(equal(expected.localizedDescription))
    }
}

func beFailureAndMatchError<T:Equatable>(_ expected: APIError) -> Predicate<Result<T, Error>>  {
    beFailure{
        error in
        expect(error.localizedDescription).to(equal(expected.localizedDescription))
    }
}

func beFailureAndNotMatchError(_ expected: APIError) -> Predicate<Result<Data, Error>>  {
    beFailure{
        error in
        expect(error.localizedDescription).toNot(equal(expected.localizedDescription))
    }
}

func beLoadedStateMoviesCount(_ expectedCount: Int) -> Predicate<LoadableEnums<Array<MoviesListViewModel.MovieItem>, Int>.State> {
    beLoadedState{
        movies in
        expect(movies.count).to(equal(expectedCount))
    }
}

func beLoadedState<Loaded, Start>(
    test: ((Loaded) -> Void)? = nil
) -> Predicate<LoadableEnums<Loaded, Start>.State> {
    return Predicate.define { expression in
        var rawMessage = "be <loaded State value>"
        if test != nil {
            rawMessage += " that satisfies block"
        }
        let message = ExpectationMessage.expectedActualValueTo(rawMessage)

        guard case let .loaded(value)? = try expression.evaluate() else {
            return PredicateResult(status: .doesNotMatch, message: message)
        }

        var matches = true
        if let test = test {
            let assertions = gatherFailingExpectations {
                test(value)
            }
            let messages = assertions.map { $0.message }
            if !messages.isEmpty {
                matches = false
            }
        }

        return PredicateResult(bool: matches, message: message)
    }
}
