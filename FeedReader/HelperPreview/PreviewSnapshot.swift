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
