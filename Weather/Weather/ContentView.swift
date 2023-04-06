//
//  ContentView.swift
//  Weather
//
//  Created by Vishnu Ankinapalli on 4/3/23.
//

import SwiftUI
import WeatherModel

struct RootView: UIViewControllerRepresentable {
    @EnvironmentObject var network: NetworkManager
    
    typealias UIViewControllerType = WeatherRootViewController
    
    func makeUIViewController(context: Context) -> WeatherRootViewController {
        return WeatherRootViewController(style: .doubleColumn, networkManager: network)
    }
    
    func updateUIViewController(_ uiViewController: WeatherRootViewController, context: Context) {
        // TODO
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
           RootView()
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
