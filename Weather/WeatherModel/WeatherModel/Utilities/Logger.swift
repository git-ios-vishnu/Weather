//
//  Logger.swift
//  WeatherModel
//
//  Created by Vishnu Ankinapalli on 4/4/23.
//

import Foundation

// To print the log with class and method names 
public func logTraceInfo(_ message: String = "", file: String = #file, function: String = #function, line: Int = #line ) {
    let fileName = file.components(separatedBy: "/").last ?? ""
    print("[Weather Trace]: \(fileName) - \(line) \(function) \(message)")
}
