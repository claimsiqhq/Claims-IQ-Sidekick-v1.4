//
//  CalendarService.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import Foundation
import EventKit

class CalendarService {
    static let shared = CalendarService()
    
    private let eventStore = EKEventStore()
    
    private init() {}
    
    func requestAccess() async -> Bool {
        do {
            return try await eventStore.requestFullAccessToEvents()
        } catch {
            return false
        }
    }
    
    func openO365Calendar() {
        // Deep link to Outlook/O365 calendar
        if let url = URL(string: "ms-outlook://calendar") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                // Fallback to web version
                if let webURL = URL(string: "https://outlook.office.com/calendar") {
                    UIApplication.shared.open(webURL)
                }
            }
        }
    }
    
    func addClaimInspectionEvent(
        claimNumber: String,
        address: String,
        startDate: Date,
        duration: TimeInterval = 3600 // 1 hour default
    ) async -> Bool {
        let hasAccess = await requestAccess()
        guard hasAccess else { return false }
        
        let event = EKEvent(eventStore: eventStore)
        event.title = "Inspection: \(claimNumber)"
        event.location = address
        event.startDate = startDate
        event.endDate = startDate.addingTimeInterval(duration)
        event.calendar = eventStore.defaultCalendarForNewEvents
        event.notes = "Claims IQ Sidekick inspection appointment"
        
        do {
            try eventStore.save(event, span: .thisEvent)
            return true
        } catch {
            print("Error saving event: \(error)")
            return false
        }
    }
    
    func getTodayEvents() async -> [CalendarEvent] {
        let hasAccess = await requestAccess()
        guard hasAccess else { return [] }
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = eventStore.predicateForEvents(withStart: startOfDay, end: endOfDay, calendars: nil)
        let events = eventStore.events(matching: predicate)
        
        return events.map { event in
            CalendarEvent(
                title: event.title,
                location: event.location,
                startDate: event.startDate,
                endDate: event.endDate
            )
        }
    }
}

struct CalendarEvent {
    let title: String
    let location: String?
    let startDate: Date
    let endDate: Date
}


