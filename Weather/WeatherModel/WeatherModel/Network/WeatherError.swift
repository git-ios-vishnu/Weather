//
//  WMResponseError.swift
//  WeatherModel
//
//  Created by Vishnu Ankinapalli on 4/3/23.
//

import Foundation

public enum WeatherError: Error {
case httpError
case failedWithHTTPStatusCode(statusCode: Int)
case invalidData
case jsonParsingFailure
}
