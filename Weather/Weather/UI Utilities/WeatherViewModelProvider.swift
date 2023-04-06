//
//  WeatherViewModelProvider.swift
//  Weather
//
//  Created by Vishnu Ankinapalli on 4/4/23.
//

import Foundation
import WeatherModel

class WeatherViewModelProvider: ObservableObject {
    
    let primaryWeatherURLSession = WeatherURLSession(timeOut: NetworkConstants.defaultTimeOut)
    let network: Network
    
    init() {
        network = Network(primaryURLSession: primaryWeatherURLSession)
    }

}
