//
//  InspectionWorkflow.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import Foundation
import SwiftData

@Model
final class InspectionWorkflow {
    var createdDate: Date
    var aiPrompt: String // The prompt used to generate the workflow
    var aiResponse: String // Raw AI response
    var title: String
    var workflowDescription: String
    
    // Relationships
    var claim: Claim?
    @Relationship(deleteRule: .cascade) var steps: [InspectionStep] = []
    
    init(title: String, description: String, aiPrompt: String = "", aiResponse: String = "") {
        self.createdDate = Date()
        self.title = title
        self.workflowDescription = description
        self.aiPrompt = aiPrompt
        self.aiResponse = aiResponse
    }
}

@Model
final class InspectionStep {
    var stepNumber: Int
    var title: String
    var stepDescription: String
    var isCompleted: Bool
    var completedDate: Date?
    
    // Relationships
    var workflow: InspectionWorkflow?
    @Relationship(deleteRule: .cascade) var items: [InspectionItem] = []
    
    init(stepNumber: Int, title: String, description: String = "") {
        self.stepNumber = stepNumber
        self.title = title
        self.stepDescription = description
        self.isCompleted = false
    }
}

@Model
final class InspectionItem {
    var title: String
    var itemDescription: String
    var isCompleted: Bool
    var completedDate: Date?
    var notes: String?
    
    // Relationships
    var step: InspectionStep?
    
    init(title: String, description: String = "") {
        self.title = title
        self.itemDescription = description
        self.isCompleted = false
    }
}


