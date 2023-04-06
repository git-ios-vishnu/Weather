//
//  DetailHeaderView.swift
//  Weather
//
//  Created by Vishnu Ankinapalli on 4/5/23.
//

import Foundation
import SwiftUI
import WeatherModel

// Header in details container
struct DetailHeaderView: View {
    let cityWeather : CityWeather
    @Environment(\.colorScheme) var coloScheme

    var weatherName: String {
        var result = ""
        if let weather = cityWeather.weather?.first?.main {
            result = weather
        }
        return result
    }
    
    var temperature: String {
        return "\(Int(cityWeather.main?.temp ?? 0))°"
    }

    var body: some View {
        VStack {
            Text(cityWeather.name ?? "")
                .font(.largeTitle)
                .fontWeight(.medium)
            Text(weatherName)
                .font(.body)
                .fontWeight(.light)
                .padding(.bottom, 4)
            Text(temperature)
                .font(.system(size: 86))
                .fontWeight(.thin)
        }
        .padding(.vertical, 24)
    }
}

