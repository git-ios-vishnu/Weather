//
//  BackGroundView.swift
//  Weather
//
//  Created by Vishnu Ankinapalli on 4/5/23.
//

import Foundation
import SwiftUI

struct BackgroundView: View {
    @Environment(\.colorScheme) var colorScheme
    
    // FIXME: These colors have to be changed
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [colorScheme == .dark  ? .black: .clear, colorScheme == .dark ? .gray: .clear]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
    }
}
