//
//  Int.swift
//  FeedReader
//
//  Created by Stan Gajda on 30/01/2024.
//

import Foundation

extension Int {
    func formatNumber() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let number = NSNumber(value: self)
        guard let formattedNumber = numberFormatter.string(from: number) else {
            return String()
        }
        return formattedNumber
    }
}
