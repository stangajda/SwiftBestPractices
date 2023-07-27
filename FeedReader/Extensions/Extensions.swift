//
//  Extensions.swift
//  FeedReader
//
//  Created by Stan Gajda on 05/08/2021.
//

import Foundation
import PreviewSnapshots

extension Array where Element == MoviesSubItem{
    func getNameOnly() -> Array<String>{
        self.map { item -> String in
            return item.name
        }
    }
}

extension Array where Element == MoviesSubLanguages{
    func groupValues() -> String{
        return self.map { item in
            item.name
        }.joined(separator: ", ")
    }
}

extension Double{
    func halfDivide() -> Double{
        return Double(self/2)
    }
}

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

extension Int {
    func formatNumber() -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let number = NSNumber(value:self)
        guard let formattedNumber = numberFormatter.string(from: number) else {
            return String()
        }
        return formattedNumber
    }
}

public extension PreviewSnapshots<Any>.Configuration {
    init(named name: Injection.Name) {
        self.init(name: name.rawValue, state: String())
    }
}

public extension PreviewSnapshots.Configuration {
    init(named name: Injection.Name, state: State) {
        self.init(name: name.rawValue, state: state)
    }
}
