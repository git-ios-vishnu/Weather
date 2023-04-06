//
//  Network.swift
//  WeatherModel
//
//  Created by Vishnu Ankinapalli on 4/3/23.
//

import Foundation

public struct NetworkConstants {
    public static let defaultTimeOut = 120.0
    public static let retries = 3
}

// Defined Backend calls as a protocol so that we could fetch data in whatever format we wanted(JSON/XML)
// Also, this way caller doesn't have to know the implementation of network data type
public protocol BackendCalls {
    // Fetch cities by name or zip
    func fetchCitiesBy(nameOrZip: String?, completion: @escaping (_ cities: [City]?, _ error: Error?) -> ())
    
    // Fetch weather for a city
    func fetchWeather(for city:City, completion: @escaping (_ weather: CityWeather?,_ error: Error?) -> ())
}

public class Network:BackendCalls, ObservableObject {
    
    private var primaryURLSession: WeatherURLSession
    
    public init(primaryURLSession: WeatherURLSession = WeatherURLSession(timeOut: NetworkConstants.defaultTimeOut)) {
        self.primaryURLSession = primaryURLSession
    }
    
    // Returns the cities by using either zip or city name search
    // First checks for zip and then city
    public func fetchCitiesBy(nameOrZip: String?, completion: @escaping ([City]?, Error?) -> ()) {
        
        let urlRequest = URLRequest.urlRequest(forCitieByNameOrZip: nameOrZip)
        
        if let urlRequest = urlRequest {
            primaryURLSession.taskWithRequest(urlRequest: urlRequest, serviceName: "citySearch", retries: NetworkConstants.retries) { data, error in
                
                if error != nil {
                    completion(nil, error)
                }
                else if let data = data {
                    var results: [City]?
                    if URLRequest.isValid(zipcode: nameOrZip) {
                        var result: City?
                        result = JSONSerializationHelper.decodeResponse(data: data)
                        
                        if let city = result {
                            results = [city]
                        }
                    }
                    else if URLRequest.isValid(cityName: nameOrZip) {
                        results = JSONSerializationHelper.decodeResponse(data: data)
                    }
                    
                    if let results = results, !results.isEmpty {
                        completion(results, nil)
                    }
                    else {
                        completion(nil, WeatherError.jsonParsingFailure)
                    }
                }
            }
        }
    }
    
    // Returns the weather for city
    public func fetchWeather(for city: City, completion: @escaping (CityWeather?, Error?) -> ()) {
        let urlRequest = URLRequest.URLRequestForWeather(of: city)
        
        if let urlRequest = urlRequest {
            primaryURLSession.taskWithRequest(urlRequest: urlRequest, serviceName: "WeatherLookup",retries: NetworkConstants.retries) { data, error in
                
                if let error {
                    completion(nil, error)
                }
                else if let data = data {
                    var result: CityWeather?
                    result = JSONSerializationHelper.decodeResponse(data: data)
                    
                    if let result = result {
                        completion(result, nil)
                    }
                    else {
                        completion(result, WeatherError.jsonParsingFailure)
                    }
                }
            }
        }
    }
}
