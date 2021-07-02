//
//  Helper.swift
//  FeedReader
//
//  Created by Stan Gajda on 22/06/2021.
//

import Foundation

class Helper{
    
    static func load(_ filename: String) -> Data {
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
                fatalError("Couldn't find \(filename) in main bundle.")
        }

        do {
            return try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
    }
    
}
