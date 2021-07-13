//
//  Helper.swift
//  FeedReader
//
//  Created by Stan Gajda on 13/07/2021.
//

struct Helper{
    static func printFailure(_ message: Any, line: Int = #line, function: String = #function, file: String = #file ) {
        #if DEBUG
            let className = file.components(separatedBy: "/").last
            print(" ❌ Error ---> File: \(className ?? ""), Function: \(function), Line: \(line),❗️Error Message : \(message) 🛑")
        #endif
    }
    
    static func printTrace(_ message: Any, line: Int = #line, function: String = #function, file: String = #file ) {
        #if DEBUG
            let className = file.components(separatedBy: "/").last
            print(" ✴️ Trace ---> File: \(className ?? ""), Function: \(function), Line: \(line),🔶 Message : \(message) 🔶")
        #endif
    }
}
