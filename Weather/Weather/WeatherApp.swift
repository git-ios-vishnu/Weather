//
//  WeatherApp.swift
//  Weather
//
//  Created by Vishnu Ankinapalli on 4/3/23.
//

import SwiftUI

// FIXME: Accessibility is not tested and we have to check
// FIXME: UI needs lot of polishing with the colors and stuff(dark mode looks better and couldn't get the right color for light)
// FIXME: If time permits I could have used coredata for local storage and use iCloud to save at remote and share across their devices
// FIXME: Errors are not displayed to user instead they're being logged in console. we could improve it to show to user
// FIXME: APIKEY is hardcoded..there should have been option for user to enter or some login screen
// FIXME: we could refresh the weather for every certain intervals(either by timer or dispatch selectors)
// FIXME: Not tested in device for current location city
// FIXME: App icon generated through some online portal so App icons are pixellated
// FIXME: Need to add progress indicators while network calls in progress
// FIXME: Need to add test cases
// FIXME: Localization support is not fully implemented
@main
struct WeatherApp: App {
    let weatherViewModelProvider = WeatherViewModelProvider()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(weatherViewModelProvider.network)
        }
    }
}
