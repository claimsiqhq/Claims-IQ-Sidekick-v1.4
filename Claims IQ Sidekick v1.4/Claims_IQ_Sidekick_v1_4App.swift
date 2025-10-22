//
//  Claims_IQ_Sidekick_v1_4App.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import SwiftUI
import SwiftData

@main
struct Claims_IQ_Sidekick_v1_4App: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            Claim.self,
            FNOL.self,
            InspectionWorkflow.self,
            InspectionStep.self,
            InspectionItem.self,
            Photo.self,
            LiDARScan.self,
            DailyInsight.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
