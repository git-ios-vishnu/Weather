//
//  WeatherCitiesListViewController.swift
//  Weather
//
//  Created by Vishnu Ankinapalli on 4/4/23.
//

import Foundation
import UIKit
import WeatherModel
import MapKit
import SwiftUI

// FIXME: I should have used collectionView but since TableView implementation is super simple so went with this
extension Notification.Name {
    static let didSelectCity = Notification.Name("didSelectCity")
}

// FIXME: Now allows duplicate entries of cities in weather list and have to make a change to avoid
// FIXME: Lot of UI optimations and background colors has to be adjusted to make UI look good
// FIXME: Haven't tested accessibility and we should test
class WeatherCitiesListViewController: UITableViewController, WeatherSearchResultsViewControllerDelegate {
    
    private struct Constants {
        static let cellReuseIdentifier = "cityCellResuseIdentifier"
        static let currentCityUserDefaultsKey = "currentCityUserDefaultsKey"
    }
    
    var cities: [CityWeather]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var network: BackendCalls
    var searchController: UISearchController?
    var searchResultsViewController: WeatherSearchResultsViewController?
    
    private(set) var _currentLocation: CLLocation?
    private var currentLocation: CLLocation? {
        
        if let location = _currentLocation {
            return location
        }
        else {
            let locationManager = CLLocationManager()
            locationManager.requestWhenInUseAuthorization()
            
            if (locationManager.authorizationStatus == CLAuthorizationStatus.authorizedWhenInUse ||
                locationManager.authorizationStatus == CLAuthorizationStatus.authorizedAlways) {
                _currentLocation = locationManager.location
            }
            return _currentLocation
        }
    }
    
    var currentLocationCity: City? {
        if let location = currentLocation {
            let city = City(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude, name: "My Location", country: nil, zip: nil)
            return city
        }
        else {
            return nil
        }
    }
    
    init(cities: [CityWeather] = [], network: BackendCalls) {
        self.cities = cities
        self.network = network
        
        super.init(style: .grouped)
        
        if let currentLocationCity = currentLocationCity {
            self.network .fetchWeather(for: currentLocationCity) {[weak self] weather, error in
                if let weather = weather {
                    self?.cities?.insert(weather, at: 0)
                }
            }
        }
        
        retreiveSavedCityIfExists()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        logTraceInfo()
        self.view.backgroundColor = .systemBackground
        
        if let background = UIHostingController(rootView: BackgroundView()).view {
            self.tableView.backgroundView = background
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "WeatherCityTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.cellReuseIdentifier)
        
        // FIXME: Localization could be improved. Not spending time on it for now to complete the proj
        self.navigationItem.title = NSLocalizedString("Weather", comment: "[WeatherSearchTableView Title]: Title of weather search table")
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        searchResultsViewController = WeatherSearchResultsViewController(network: self.network, delegate: self)
        searchController = UISearchController(searchResultsController: searchResultsViewController)
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController?.searchResultsUpdater = searchResultsViewController
        searchController?.delegate = searchResultsViewController
        searchController?.obscuresBackgroundDuringPresentation = true
        searchController?.searchBar.placeholder = NSLocalizedString("Search for a city or zip", comment: "[SearchBar PlaceHolder]: Placeholder string used in search bar to search for weather")
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    func doesWeatherExistsFor(city: CityWeather) -> Bool {
        let cityWeather = self.cities?.first(where: { $0.id == city.id })
        return cityWeather != nil ? true : false
    }
    
    func add(cityWeather: CityWeather) {
        
        if !self.doesWeatherExistsFor(city: cityWeather) {
            self.cities?.append(cityWeather)
            self.postNotification(forCurrentSelection: cityWeather)
        }
    }
    
    func didSelect(city: WeatherModel.City) {
        self.network .fetchWeather(for: city) {[weak self] weather, error in
            
            if let weather = weather {
                self?.add(cityWeather: weather)
            }
        }
        searchController?.searchBar.text = nil
    }

}

extension WeatherCitiesListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cities?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier) as! WeatherCityTableViewCell

        if let city = cities?[indexPath.section] {
            cell.update(withCityWeather: city)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cityWeather = cities?[indexPath.section] {
            postNotification(forCurrentSelection: cityWeather)
        }
    }
    
    func postNotification(forCurrentSelection cityWeather: CityWeather) {
        let userInfo = ["currentCityWeatherKey": cityWeather]
        let notification = Notification(name: .didSelectCity, userInfo: userInfo)
        NotificationCenter.default.post(notification)
        
        if let splitViewController = splitViewController, splitViewController.isCollapsed {
            splitViewController.show(.secondary)
        }
        
        saveCurren(city: cityWeather.city())
    }

}

// Saving data for persistance
//FIXME: For better experience and scalability we can go to CoreData in local
extension WeatherCitiesListViewController {
    
    func saveCurren(city: City) {
        if let data = try? JSONEncoder().encode(city) {
            UserDefaults.standard.set(data, forKey: Constants.currentCityUserDefaultsKey)
        }
    }
    
    func retreiveSavedCityIfExists() {
        
        var city: City? = nil
        if let data = UserDefaults.standard.object(forKey: Constants.currentCityUserDefaultsKey) as? Data {
            do {
                city = try JSONDecoder().decode(City.self, from:data)
            }
            catch let error {
                print(error)
            }
        }
        
        if let city = city {
            network.fetchWeather(for: city) {[weak self] weather, error in
                if let weather = weather {
                    self?.add(cityWeather: weather)
                }
                else if let error = error {
                    print(error)
                }
            }
        }
    }
}
