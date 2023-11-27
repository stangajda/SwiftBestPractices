//
//  Helper.swift
//  FeedReader
//
//  Created by Stan Gajda on 22/06/2021.
//

import Foundation
import Nimble
import UIKit
import PreviewSnapshots
import PreviewSnapshotsTesting
import SwiftUI

// MARK: - Result

extension Data {
    static var stubData: Data {
        return Data([0,1,0,1])
    }
}

func beSuccessAndEqual(_ expected: Data) -> Matcher<Result<Data, Error>>  {
    beSuccess{
        value in
        expect(value).to(equal(expected))
    }
}

func beSuccessAndEqual<T:Equatable>(_ expected: T) -> Matcher<Result<T, Error>>  {
    beSuccess{
        value in
        expect(value).to(equal(expected))
    }
}

func beSuccessAndNotEqual<T:Equatable>(_ expected: T) -> Matcher<Result<T, Error>>  {
    beSuccess{
        value in
        expect(value).toNot(equal(expected))
    }
}

func beFailureAndMatchError(_ expected: APIError) -> Matcher<Result<Data, Error>>  {
    beFailure{
        error in
        expect(error.localizedDescription).to(equal(expected.localizedDescription))
    }
}

func beFailureAndMatchError<T:Equatable>(_ expected: APIError) -> Matcher<Result<T, Error>>  {
    beFailure{
        error in
        expect(error.localizedDescription).to(equal(expected.localizedDescription))
    }
}

func beFailureAndNotMatchError(_ expected: APIError) -> Matcher<Result<Data, Error>>  {
    beFailure{
        error in
        expect(error.localizedDescription).toNot(equal(expected.localizedDescription))
    }
}

func beLoadedStateMoviesCount(_ expectedCount: Int) -> Matcher<LoadableEnums<Array<MoviesListViewModel.MovieItem>, Int>.State> {
    beLoadedState{
        movies in
        expect(movies.count).to(equal(expectedCount))
    }
}

func beLoadedState<Loaded, Start>(
    test: ((Loaded) -> Void)? = nil
) -> Matcher<LoadableEnums<Loaded, Start>.State> {
    return Predicate.define { expression in
        var rawMessage = "be <loaded State value>"
        if test != nil {
            rawMessage += " that satisfies block"
        }
        let message = ExpectationMessage.expectedActualValueTo(rawMessage)

        guard case let .loaded(value)? = try expression.evaluate() else {
            return MatcherResult(status: .doesNotMatch, message: message)
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

        return MatcherResult(bool: matches, message: message)
    }
}

func convertImageToData(_ uiImage: UIImage?) -> Data {
    guard let imageData = uiImage?.pngData() else {
        fatalError("Error: Can not convert image to data")
    }
    return imageData
}

extension PreviewSnapshots {
    private func getView( _ name: Injection.Name? = nil) -> AnyView {

        guard let name = name else {
            return configurations
                .map { configuration in
                    configure(configuration.state)
                }
                .first ?? AnyView.errorNoViewFound()
        }

        let view = configurations
            .filter { configuration in
                configuration.name == name.rawValue
            }
            .map { configuration in
                configure(configuration.state)
            }
            .first
        
        guard let view = view else {
            return AnyView.errorNoViewFound()
        }

        return view
    }

    func getViewController( _ name: Injection.Name? = nil) -> UIHostingController<AnyView> {
        let view = getView(name)
        return UIHostingController(rootView: view)
    }
}
