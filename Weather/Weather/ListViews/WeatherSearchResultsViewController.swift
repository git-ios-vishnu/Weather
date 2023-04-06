//
//  WeatherSearchResultsViewController.swift
//  Weather
//
//  Created by Vishnu Ankinapalli on 4/4/23.
//

import Foundation
import UIKit
import WeatherModel
import SwiftUI

protocol WeatherSearchResultsViewControllerDelegate {
    func didSelect(city: City)
}

class WeatherSearchResultsViewController: UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate {
    
    let network: BackendCalls
    var searchResults: [City]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var delegate: WeatherSearchResultsViewControllerDelegate
    
    private struct Constants {
        static let cellResuseIdentifier = "searchResultsCellReuseIdentifier"
    }
    
    init(network: BackendCalls, delegate: WeatherSearchResultsViewControllerDelegate) {
        self.network = network
        self.delegate = delegate
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        logTraceInfo()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellResuseIdentifier)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        searchResults = nil
        self.network.fetchCitiesBy(nameOrZip: searchController.searchBar.text) {[weak self] cities, error in
            
            if let cities = cities {
                self?.searchResults = cities
            }
            else {
                print(error ?? "No message in error")
            }
        }
    }
   
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellResuseIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier:Constants.cellResuseIdentifier)
        var contentConfiguration = cell.defaultContentConfiguration()
        let city = searchResults?[indexPath.row]
        cell.backgroundColor = .clear
        
        if let city = city, let name = city.name {
            contentConfiguration.text = name + " " + (city.country ?? "")
        }
       
        cell.contentConfiguration = contentConfiguration
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        logTraceInfo()
        
        if let city = searchResults?[indexPath.row] {
            self.delegate.didSelect(city: city)
            self.dismiss(animated: true)
            self.searchResults = nil
        }
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        self.searchResults = nil
        searchController.searchBar.text = nil
    }
    
}
