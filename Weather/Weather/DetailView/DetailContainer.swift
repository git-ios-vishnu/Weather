//
//  DetailView.swift
//  Weather
//
//  Created by Vishnu Ankinapalli on 4/5/23.
//

import Foundation
import SwiftUI
import WeatherModel

struct DetailContainer: View {
    let cityWeather: CityWeather
    @Environment(\.colorScheme) var coloScheme
    
    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView {
                VStack {
                    Spacer()
                    DetailHeaderView(cityWeather: cityWeather)
                    Spacer()
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            DetailSummary(currentWeather: cityWeather)
                            Rectangle().frame(height: CGFloat(1))
                            
                            Text(cityWeather.weatherDescription())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(
                                    .init(arrayLiteral:.leading,.trailing),
                                    24
                                )
                            Rectangle().frame(height: CGFloat(1))
                            
                            WhetherDetailView(cityWeather: cityWeather)
                            Rectangle().frame(height: CGFloat(1))
                            
                        }
                    }
                    Spacer()
                    
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
        .colorScheme(coloScheme)
    }
}

