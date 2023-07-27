//
//  ExtensionView.swift
//  FeedReader
//
//  Created by Stan Gajda on 27/07/2023.
//

import Foundation
import SwiftUI

extension AnyView {
    static func errorNoViewFound(function: String = #function, file: String = #file, line: Int = #line) -> AnyView {
        let errorMessage = "Snapshot error: No view found (function: \(function) file: \(file), line: \(line))"
        return AnyView(Text(errorMessage)
            .padding()
            .background(Color.red)
            .foregroundColor(Color.black))
    }
}
