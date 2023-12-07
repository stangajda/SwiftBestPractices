//
//  PreviewSnapshot.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 07/12/2023.
//

import Foundation
import PreviewSnapshots
import SwiftUI

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

extension AnyView {
    static func errorNoViewFound(function: String = #function, file: String = #file, line: Int = #line) -> AnyView {
        let errorMessage = "Snapshot error: No view found (function: \(function) file: \(file), line: \(line))"
        return AnyView(Text(errorMessage)
            .padding()
            .background(Color.red)
            .foregroundColor(Color.black))
    }
}
