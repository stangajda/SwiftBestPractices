//
//  String.swift
//  FeedReader
//
//  Created by Stan Gajda on 30/01/2024.
//

import Foundation

extension String {
    private func toDateFormatter() -> DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            return formatter
    }

    private func toDate() -> Date? {
        return toDateFormatter().date(from: self)
    }

    func toStringDate() -> String {
        let formatter = toDateFormatter()
        formatter.dateFormat = "d MMM yy"
        guard let date = toDate() else {
            return String()
        }
        return formatter.string(from: date)
    }

    func isNotZero() -> Bool {
        return self != "0"
    }

    func addDollar() -> String {
        return "$\(self)"
    }

}
