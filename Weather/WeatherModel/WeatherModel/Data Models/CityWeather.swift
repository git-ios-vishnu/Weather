//
//  Weather.swift
//  WeatherModel
//
//  Created by Vishnu Ankinapalli on 4/3/23.
//

import Foundation

/*
 Made all All values as optional as I don't know which values are mandatory and which are not
 */

public struct Coordinates: Codable {
    public let longitude: Double
    public let latitude: Double
    
    init (longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
    }
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }

}

public struct weatherCondition: Codable {
    public let id: Int?
    public let main: String?
    public let weatherDescription: String?
    public let icon: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id, main, icon
        case weatherDescription = "description"
    }
}

public struct WeatherMainValue: Codable {
    public let temp: Double?
    public let feelsLike: Double?
    public let tempMin: Double?
    public let tempMax: Double?
    public let pressure: Int?
    public let humidity: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

public struct WeatherWind: Codable {
    public let speed: Double?
    public let deg: Int?
    public let gust: Double?
}

public struct WeatherClouds: Codable {
    public let all: Int?
}

public struct WeatherSys: Codable {
    public let type: Int?
    public let id: Int?
    public let country: String?
    public let sunrise: Int?
    public let sunset: Int?
}

public struct Rain: Codable {
    public let hr1 : Double?
    
    enum CodingKeys: String, CodingKey {
        case hr1 = "1hr"
    }
}

public class CityWeather: Codable, ObservableObject {
    
    public let coordinates: Coordinates?
    public let weather: [weatherCondition]?
    public let base: String?
    public let main: WeatherMainValue?
    public let visibility: Int?
    public let wind: WeatherWind?
    public let rain: Rain?
    public let clouds: WeatherClouds?
    public let date: Int?
    public let sys: WeatherSys?
    public let timezone: Int?
    public let id: Int?
    public let name: String?
    public let code: Int?
    
    init(coordinates: Coordinates?, weather: [weatherCondition]?, base: String?, main: WeatherMainValue?, visibility: Int?, wind: WeatherWind?, rain: Rain?, clouds: WeatherClouds?, date: Int?, sys: WeatherSys?, timezone: Int?, id: Int?, name: String?, code: Int?) {
        self.coordinates = coordinates
        self.weather = weather
        self.base = base
        self.main = main
        self.visibility = visibility
        self.wind = wind
        self.rain = rain
        self.clouds = clouds
        self.date = date
        self.sys = sys
        self.timezone = timezone
        self.id = id
        self.name = name
        self.code = code
    }
   
    enum CodingKeys:String, CodingKey {
        case coordinates = "coord"
        case weather
        case base
        case main
        case visibility
        case wind
        case rain
        case clouds
        case date = "dt"
        case sys
        case timezone
        case id
        case name
        case code = "cod"
    }
    
    public func city() -> City {
        return City(longitude: self.coordinates?.longitude, latitude: self.coordinates?.latitude, name: self.name, country: nil, zip: nil)
    }
    
    public func weatherDescription() -> String {
        var result = "Today: "
        if let description = self.weather?.first?.weatherDescription {
            result += "\(description.capitalizingFirstLetter()) currently. "
        }
        result += "It's \(main?.temp ?? 0)°."
        return result
    }
}
