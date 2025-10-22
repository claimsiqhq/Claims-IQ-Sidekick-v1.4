//
//  DailyInsight.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import Foundation
import SwiftData

@Model
final class DailyInsight {
    var date: Date
    var aiPrompt: String // Prompt sent to AI
    var aiResponse: String // Raw AI response
    var insights: String // JSON array of insight strings
    var priorities: String // JSON array of priority items
    var suggestions: String // JSON array of suggestions
    
    // Context data used for generation
    var activeClaimsCount: Int
    var pendingTasksCount: Int
    var weatherCondition: String?
    var userLocation: String?
    
    // Status
    var generationStatus: String // "pending", "generating", "completed", "failed"
    var lastRefreshedDate: Date?
    
    init() {
        self.date = Date()
        self.aiPrompt = ""
        self.aiResponse = ""
        self.insights = "[]"
        self.priorities = "[]"
        self.suggestions = "[]"
        self.activeClaimsCount = 0
        self.pendingTasksCount = 0
        self.generationStatus = "pending"
    }
}


