//
//  WeatherWidget.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import SwiftUI

struct WeatherWidget: View {
    @State private var currentTemp = 72
    @State private var condition = "Partly Cloudy"
    @State private var high = 78
    @State private var low = 65
    
    var body: some View {
        HStack(spacing: Theme.paddingMedium) {
            // Current conditions
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: weatherIcon)
                        .font(.system(size: 32))
                        .foregroundColor(Theme.accentPrimary)
                    
                    Text("\(currentTemp)°")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(Theme.dark)
                }
                
                Text(condition)
                    .font(Theme.callout)
                    .foregroundColor(Theme.dark.opacity(0.7))
            }
            
            Spacer()
            
            // High/Low
            VStack(alignment: .trailing, spacing: 8) {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.up")
                        .font(.caption)
                        .foregroundColor(.red)
                    Text("\(high)°")
                        .font(Theme.callout)
                        .foregroundColor(Theme.dark)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "arrow.down")
                        .font(.caption)
                        .foregroundColor(.blue)
                    Text("\(low)°")
                        .font(Theme.callout)
                        .foregroundColor(Theme.dark)
                }
            }
        }
        .padding(Theme.paddingLarge)
        .background(Color.white)
        .cornerRadius(Theme.cornerRadiusLarge)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var weatherIcon: String {
        // Placeholder - will be dynamic based on actual weather
        "cloud.sun.fill"
    }
}

#Preview {
    WeatherWidget()
        .padding()
}

