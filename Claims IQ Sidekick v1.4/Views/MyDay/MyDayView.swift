//
//  MyDayView.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import SwiftUI

struct MyDayView: View {
    @State private var isLoadingInsights = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.paddingLarge) {
                    // Header
                    headerSection
                    
                    // AI Insights Card
                    InsightsCard(isLoading: $isLoadingInsights)
                    
                    // Weather Widget
                    WeatherWidget()
                    
                    // Today's Priorities
                    prioritiesSection
                    
                    // Active Claims with Routes
                    activeClaimsSection
                }
                .padding()
            }
            .background(Theme.neutral3.ignoresSafeArea())
            .navigationTitle("My Day")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Open O365 Calendar
                    }) {
                        Image(systemName: "calendar")
                            .foregroundColor(Theme.primary)
                    }
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Good Morning")
                .font(Theme.callout)
                .foregroundColor(Theme.dark.opacity(0.6))
            
            Text(Date().formatted(date: .complete, time: .omitted))
                .font(Theme.headline)
                .foregroundColor(Theme.dark)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var prioritiesSection: some View {
        VStack(alignment: .leading, spacing: Theme.paddingMedium) {
            Text("Today's Priorities")
                .font(Theme.headline)
                .foregroundColor(Theme.dark)
            
            VStack(spacing: 12) {
                PriorityRow(title: "Complete Inspection #1234", time: "9:00 AM", priority: .high)
                PriorityRow(title: "Upload FNOL for Claim #5678", time: "11:30 AM", priority: .medium)
                PriorityRow(title: "Review AI Analysis", time: "2:00 PM", priority: .low)
            }
        }
    }
    
    private var activeClaimsSection: some View {
        VStack(alignment: .leading, spacing: Theme.paddingMedium) {
            Text("Active Claims")
                .font(Theme.headline)
                .foregroundColor(Theme.dark)
            
            VStack(spacing: 12) {
                ClaimRouteCard(
                    claimNumber: "CLM-001234",
                    address: "123 Main St, City, ST 12345",
                    distance: "2.3 miles",
                    eta: "15 min"
                )
                ClaimRouteCard(
                    claimNumber: "CLM-005678",
                    address: "456 Oak Ave, Town, ST 67890",
                    distance: "5.7 miles",
                    eta: "22 min"
                )
            }
        }
    }
}

struct PriorityRow: View {
    let title: String
    let time: String
    let priority: Priority
    
    enum Priority {
        case high, medium, low
        
        var color: Color {
            switch self {
            case .high: return .red
            case .medium: return Theme.accentPrimary
            case .low: return Theme.secondary
            }
        }
    }
    
    var body: some View {
        HStack {
            Circle()
                .fill(priority.color)
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(Theme.callout)
                    .foregroundColor(Theme.dark)
                Text(time)
                    .font(Theme.caption)
                    .foregroundColor(Theme.dark.opacity(0.6))
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(Theme.cornerRadiusMedium)
    }
}

#Preview {
    MyDayView()
}

