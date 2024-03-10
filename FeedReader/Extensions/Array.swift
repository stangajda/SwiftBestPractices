//
//  Array.swift
//  FeedReader
//
//  Created by Stan Gajda on 30/01/2024.
//

extension Array where Element == MoviesSubItem {
    func getNameOnly() -> [String] {
        self.map { item -> String in
            return item.name
        }
    }
}

extension Array where Element == MoviesSubLanguages {
    func groupValues() -> String {
        return self.map { item in
            item.name
        }.joined(separator: ", ")
    }
}
