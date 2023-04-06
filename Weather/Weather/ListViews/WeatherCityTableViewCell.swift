//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Vishnu Ankinapalli on 4/5/23.
//

import Foundation
import UIKit
import WeatherModel

// FIXME: Background colors and design needs refinements
class WeatherCityTableViewCell: UITableViewCell {
    var cityWeather: CityWeather?
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temparature: UILabel!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var temparatureRange: UILabel!
    
    func configureCell() {
        self.cityName.text = self.cityWeather?.name ?? "No Name"
        self.temparature.text = String(format: "%.1f°",  (self.cityWeather?.main?.temp ?? ""))
        
        self.condition.text = self.cityWeather?.weather?.first?.main ?? ""
        self.temparatureRange.text = "H:" + String(format: "%.1f°",  (self.cityWeather?.main?.tempMax ?? "")) + "  L:" + String(format: "%.1f°",  (self.cityWeather?.main?.tempMin ?? ""))
    }
    
    override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func update(withCityWeather weather: CityWeather) {
        self.cityWeather = weather
        configureCell()
    }
    
}
