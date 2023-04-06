//
//  WeatherCellView.swift
//  Weather
//
//  Created by Vishnu Ankinapalli on 4/5/23.
//

import Foundation
import SwiftUI
import WeatherModel

struct DetailSummary: View {
    let currentWeather: CityWeather
    var day:String {
        (currentWeather.sys?.sunrise ?? Int(NSDate().timeIntervalSince1970)).dateFromMilliseconds().dayWord()
    }

    var temperatureMax: String {
        return "\(Int(currentWeather.main?.tempMax ?? 0))°"
    }

    var temperatureMin: String {
        return "\(Int(currentWeather.main?.tempMin ?? 0))°"
    }
    
    var icon: String {
        var image = "50n" // Providing some default value
        if let icon = currentWeather.weather?.first?.icon {
            image = icon
        }
        return image
    }

    var body: some View {
        HStack {
            Text(day)
                .frame(width: 150, alignment: .leading)

            Image(icon)
                .resizable()
                .aspectRatio(UIImage(named: icon)!.size, contentMode: .fit)
                .frame(width: 30, height: 30)

            Spacer()
            Text(temperatureMax)
            Spacer().frame(width: 34)
            Text(temperatureMin)
        }.padding(.horizontal, 24)
    }
}
