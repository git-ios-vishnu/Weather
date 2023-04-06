//
//  String+Additions.swift
//  WeatherModel
//
//  Created by Vishnu Ankinapalli on 4/4/23.
//

import Foundation

extension String {
    
    public func urlEncode() -> String? {
        let allowedQueryParamAndKey = NSCharacterSet.urlQueryAllowed
        return self.addingPercentEncoding(withAllowedCharacters: allowedQueryParamAndKey)
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
