//
//  WMURLRequest.swift
//  WeatherModel
//
//  Created by Vishnu Ankinapalli on 4/3/23.
//

import Foundation

// This class takes care of creating URL requests

// API related endpoints and API keys
/*
 We could better manage the API keys by reading the values from keyChain.
 Get the API key at the time of login and store it in key chain
 */
/*
 End points could be moved to envioronment plist for easy access and manipulation
 */
private struct OpenWeatherAPI {
    static let APIKey = "c189a3b4515285fc0f91e3d577eef54a"
    
    static let zipSearch = "http://api.openweathermap.org/geo/1.0/zip?zip=%@&appid=\(APIKey)"
    
    static let cityByName = "http://api.openweathermap.org/geo/1.0/direct?q=%@&limit=10&appid=\(APIKey)"
    
    static let cityByCoordinates = "https://api.openweathermap.org/data/2.5/weather?units=Imperial&lat=%@&lon=%@&appid=\(APIKey)"
}

extension URLRequest {
    
    // Regex to  validate zip
    // Courtesy: Google
    public static func isValid(zipcode input: String?) -> Bool {
        guard let input = input else { return false }

        return NSPredicate(format: "SELF MATCHES %@", "^\\d{5}(?:[-\\s]?\\d{4})?$")
            .evaluate(with: input.uppercased())
    }
    
    // Regex to validate city names
    public static func isValid(cityName input: String?) -> Bool {
        guard let input = input else { return false }
        
        return NSPredicate(format: "SELF MATCHES %@", "^[a-zA-Z]+(?:[\\s-][a-zA-Z]+)*$").evaluate(with: input.uppercased())
    }
    
    // Returns the URLRequest for cities to search by name or zip
    public static func urlRequest(forCitieByNameOrZip searchString: String?) -> URLRequest? {
        
        guard let searchString = searchString else { return nil}
        
        var urlString: String?
        var urlRequest: URLRequest?
        
        if isValid(zipcode: searchString) {
            urlString = String(format: OpenWeatherAPI.zipSearch, searchString)
        }
        else if isValid(cityName: searchString) {
            urlString = String(format: OpenWeatherAPI.cityByName, searchString)
        }
        
        if let urlString = urlString?.urlEncode(), let url = URL(string: urlString) {
            urlRequest = URLRequest(url: url)
        }
        
       return urlRequest
    }
    
    // URLRequest to get weather details of a city
    static func URLRequestForWeather(of city: City) -> URLRequest? {
        
        var urlRequest: URLRequest?
        var urlString: String?
        if let latitude = city.latitude, let longitude = city.longitude {
            // Formattting for lon and lat is to remove defaults decimals added by JSONDecoder
          urlString = String(format: OpenWeatherAPI.cityByCoordinates, String(format: "%.4f", latitude), String(format: "%.4f", longitude))
        }
        
        if let urlString = urlString, let url = URL(string: urlString) {
            urlRequest = URLRequest(url: url)
        }
       
        return urlRequest
    }
}
