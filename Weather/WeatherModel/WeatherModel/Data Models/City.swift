//
//  City.swift
//  WeatherModel
//
//  Created by Vishnu Ankinapalli on 4/3/23.
//

import Foundation

public class City: Codable {
    public let longitude: Double?
    public let latitude: Double?
    public let name: String?
    public let country: String?
    public let zip: String?

    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case name
        case country
        case zip
    }
    
    public init(longitude: Double?, latitude: Double?, name: String?, country: String?, zip: String?) {
        self.longitude = longitude
        self.latitude = latitude
        self.name = name
        self.country = country
        self.zip = zip
    }

}
