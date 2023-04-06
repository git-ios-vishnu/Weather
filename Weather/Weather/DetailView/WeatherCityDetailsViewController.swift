//
//  WeatherCityDetailsViewController.swift
//  Weather
//
//  Created by Vishnu Ankinapalli on 4/4/23.
//

import Foundation
import UIKit
import WeatherModel
import SwiftUI

// Courtesy: UI is inspired by projects available in internet
// FIXME: Didn't spend much time on UI design so bare with it
class WeatherCityDetailsViewController: UIViewController {
    
    var currentCityWeather: CityWeather?
    let network: BackendCalls
    var weatherContainer: UIView?
    let noWeatherLabel: UILabel
    
    init(currentCityWeather: CityWeather? = nil, network: BackendCalls) {
        self.currentCityWeather = currentCityWeather
        self.network = network
        self.noWeatherLabel = UILabel()
        self.noWeatherLabel.text = "Please select a city for weather"
        self.weatherContainer = nil
        
        super.init(nibName: nil, bundle: nil)
        
        // Update weather for city
        updateViewWith(cityWeather: currentCityWeather)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        logTraceInfo()
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.largeTitleDisplayMode = .never

        NotificationCenter.default.addObserver(self, selector: #selector(updateView(forNotification:)), name: .didSelectCity, object: nil)
        
        updateViewWith(cityWeather: nil)
    }
    
    @objc func updateView(forNotification notification: Notification) {
        guard let cityWeather = notification.userInfo?["currentCityWeatherKey"] as? CityWeather else  { return }
        
        self.updateViewWith(cityWeather: cityWeather)
    }
    
    private func updateViewWith(cityWeather weather: CityWeather?) {
        guard let weather = weather else {
            self.view.addSubview(self.noWeatherLabel)
            self.noWeatherLabel.translatesAutoresizingMaskIntoConstraints = false
            self.noWeatherLabel.textAlignment = .center
            self.noWeatherLabel.textColor = .systemGray
            NSLayoutConstraint.activate([self.noWeatherLabel.leadingAnchor .constraint(equalTo: self.view.leadingAnchor),
                                         self.noWeatherLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                                         self.noWeatherLabel.topAnchor.constraint(equalTo: self.view.topAnchor),
                                         self.noWeatherLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)])
            return
        }
        
        // Remove existing views before adding new one
        self.noWeatherLabel.removeFromSuperview()
        self.weatherContainer?.removeFromSuperview()

        self.currentCityWeather = weather
        
        let container = UIHostingController(rootView: DetailContainer(cityWeather: weather)).view
        container?.translatesAutoresizingMaskIntoConstraints = false
        
        if let container = container {
            self.weatherContainer = container
            self.view.addSubview(container)
            container.backgroundColor = .systemGroupedBackground
            NSLayoutConstraint.activate([container.leadingAnchor .constraint(equalTo: self.view.leadingAnchor),
                                         container.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                                         container.topAnchor.constraint(equalTo: self.view.topAnchor),
                                         container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)])
        }
        
    }

}
