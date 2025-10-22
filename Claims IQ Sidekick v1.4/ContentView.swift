//
//  ContentView.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MyDayView()
                .tabItem {
                    Label("My Day", systemImage: "sun.max.fill")
                }
                .tag(0)
            
            ClaimsListView()
                .tabItem {
                    Label("Claims", systemImage: "doc.text.fill")
                }
                .tag(1)
            
            InspectionView()
                .tabItem {
                    Label("Inspection", systemImage: "camera.fill")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
        .accentColor(Theme.primary)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
