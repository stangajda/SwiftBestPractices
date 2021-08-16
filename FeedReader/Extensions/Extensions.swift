//
//  Extensions.swift
//  FeedReader
//
//  Created by Stan Gajda on 05/08/2021.
//

import Foundation

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
    func formatDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "d MMM yy"
        guard let date = date else {
            return "uknown"
        }
        return dateFormatter.string(from: date)
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
