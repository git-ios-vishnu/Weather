//
//  JSONSerialization.swift
//  WeatherModel
//
//  Created by Vishnu Ankinapalli on 4/4/23.
//

import Foundation

public class JSONSerializationHelper {
    
    public class func decodeResponse<T: Decodable>(data: Data) -> T? {
        var response: T?
        
        let decoder = JSONDecoder()
        
        do {
            response = try decoder.decode(T.self, from: data)
        }
        catch let error {
            print(error)
        }
        
        return response
    }
    
}
