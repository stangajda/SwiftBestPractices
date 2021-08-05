//
//  Extensions.swift
//  FeedReader
//
//  Created by Stan Gajda on 05/08/2021.
//

import Foundation

extension Array where Element == FDRMoviesSubItem{
    func getNameOnly() -> Array<String>{
        self.map { item -> String in
            return item.name
        }
    }
}

extension Array where Element == FDRMoviesSubLanguages{
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
        let date = Date()
        let formate = date.getFormattedDate(format: "MMM d, yyyy")
        return formate
    }
}

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
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
