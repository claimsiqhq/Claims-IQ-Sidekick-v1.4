//
//  MyDayViewModel.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import Foundation
import SwiftData
import Combine

@MainActor
class MyDayViewModel: ObservableObject {
    @Published var insights: [String] = []
    @Published var priorities: [String] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    @Published var weather: WeatherData?
    @Published var todayEvents: [CalendarEvent] = []
    
    private let openAIService = OpenAIService.shared
    private let weatherService = WeatherService.shared
    private let calendarService = CalendarService.shared
    private let locationService = LocationService.shared
    
    func loadDailyInsights(claims: [Claim]) async {
        isLoading = true
        error = nil
        
        do {
            // Prepare claim summaries
            let summaries = claims.map { claim in
                ClaimSummary(
                    claimNumber: claim.claimNumber,
                    address: claim.address,
                    status: claim.status
                )
            }
            
            // Get weather
            if let location = locationService.currentLocation {
                weather = await weatherService.getCurrentWeather(for: location)
            }
            
            // Generate insights
            let result = try await openAIService.generateDailyInsights(
                claims: summaries,
                weather: weather?.condition,
                location: locationService.currentLocation?.description
            )
            
            insights = result.insights
            priorities = result.priorities
            
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func loadWeather() async {
        guard let location = locationService.currentLocation else { return }
        weather = await weatherService.getCurrentWeather(for: location)
    }
    
    func loadTodayEvents() async {
        todayEvents = await calendarService.getTodayEvents()
    }
    
    func openCalendar() {
        calendarService.openO365Calendar()
    }
}


