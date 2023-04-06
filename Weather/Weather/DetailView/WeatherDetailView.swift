//
//  WeatherDetailView.swift
//  Weather
//
//  Created by Vishnu Ankinapalli on 4/5/23.
//

import Foundation
import SwiftUI
import WeatherModel


struct WhetherDetailView: View {
    let cityWeather: CityWeather
    
    var sunrise: String {
        return cityWeather.sys?.sunrise?.dateFromMilliseconds().hourMinute() ?? Date().hourMinute()
    }

    var sunset: String {
        return cityWeather.sys?.sunset?.dateFromMilliseconds().hourMinute() ?? Date().hourMinute()
    }
    
    var temperatureMax: String {
        return "\(Int(cityWeather.main?.tempMax ?? 0))°"
    }

    var temperatureMin: String {
        return "\(Int(cityWeather.main?.tempMin ?? 0))°"
    }

    var visibility: String {
        return "\(Float((cityWeather.visibility ?? 0)/1609)) mi"
    }

    var feelsLike: String {
        return "\(cityWeather.main?.feelsLike ?? 0)°"
    }
    
    var pressure: String {
        return "\(cityWeather.main?.pressure ?? 0) hPa"
    }

    var humidity: String {
        return "\(cityWeather.main?.humidity ?? 0)%"
    }

    var body: some View {
        VStack(spacing: 0) {
            WeatherDetailCellView(
                firstData: ("SUNRISE", sunrise),
                secondData: ("SUNSET", sunset)
            )
            Rectangle().frame(height: CGFloat(1)).padding(.vertical, 8)

            WeatherDetailCellView(
                firstData: ("PRESSURE", pressure),
                secondData: ("HUMIDITY", humidity)
            )
            Rectangle().frame(height: CGFloat(1)).padding(.vertical, 8)

            WeatherDetailCellView(
                firstData: ("VISIBILITY", visibility),
                secondData: ("FEELS LIKE", feelsLike)
            )
            Rectangle().frame(height: CGFloat(1)).padding(.vertical, 8)

            WeatherDetailCellView(
                firstData: ("HIGH TEMP", temperatureMax),
                secondData: ("LOW TEMP", temperatureMin)
            )
            Spacer()
        }.padding(.horizontal, 24)
    }
}

struct WeatherDetailCellView: View {
    let firstData: (String, String)
    let secondData: (String, String)

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(firstData.0)
                    .font(.caption)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                Text(secondData.0)
                    .font(.caption)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
            HStack(spacing: 0) {
                Text(firstData.1).font(.title).padding(0)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                Text(secondData.1).font(.title).padding(0)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

