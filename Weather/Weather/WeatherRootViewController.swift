//
//  WeatherRootViewController.swift
//  Weather
//
//  Created by Vishnu Ankinapalli on 4/4/23.
//

import Foundation
import UIKit
import WeatherModel


// FIXME: We have to figure correct the background for view so UI looks good.
// Tried some but they aren't as I expected
class WeatherRootViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    let network: BackendCalls
    var listViewController: WeatherCitiesListViewController
    var detailViewController: WeatherCityDetailsViewController
    
    init(style: UISplitViewController.Style, network: BackendCalls) {
        self.network = network
        listViewController = WeatherCitiesListViewController(network: network)
        detailViewController = WeatherCityDetailsViewController(network: network)

        super.init(style: style)
    }
    
    override func viewDidLoad() {
        logTraceInfo()
        
        let listNavigationViewController = UINavigationController(rootViewController: listViewController)
        
        self.setViewController(listNavigationViewController, for: .primary)
        self.setViewController(detailViewController, for: .secondary)
        
        self.delegate = self
        self.view.clipsToBounds = true
        self.preferredDisplayMode = .automatic
        self.presentsWithGesture = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // Show Primary column as the firstView in compact classes
        if self.traitCollection.horizontalSizeClass == .compact && self.detailViewController.currentCityWeather == nil {
            self.show(.primary)
        }
    }
}
