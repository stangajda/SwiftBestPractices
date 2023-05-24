//
//  Helper.swift
//  FeedReader
//
//  Created by Stan Gajda on 13/07/2021.
//

import Foundation


func printFailure(_ message: Any, line: Int = #line, function: String = #function, file: String = #file ) {
        #if DEBUG
            let className = file.components(separatedBy: "/").last
            print(" ❌ Error ---> File: \(className ?? ""), Function: \(function), Line: \(line),❗️Error Message : \(message) 🛑")
        #endif
    }
    
func printTrace(_ message: Any, line: Int = #line, function: String = #function, file: String = #file ) {
        #if DEBUG
            let className = file.components(separatedBy: "/").last
            print(" ✴️ Trace ---> File: \(className ?? ""), Function: \(function), Line: \(line),🔶 Message : \(message) 🔶")
        #endif
}

extension Data{
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

    static func jsonDataToObject<T:Decodable>(_ filename: String) -> T where T: Encodable {
        let data = Data.load(filename)
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
}

