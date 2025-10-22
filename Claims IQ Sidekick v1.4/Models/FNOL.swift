//
//  FNOL.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import Foundation
import SwiftData

@Model
final class FNOL {
    var uploadDate: Date
    var documentPath: String // Local file path to PDF
    var extractedText: String
    var aiAnalysis: String // JSON string of AI-parsed data
    var processingStatus: String // "pending", "processing", "completed", "failed"
    
    // Extracted data fields
    var dateOfLoss: Date?
    var timeOfLoss: String?
    var lossType: String?
    var cause: String?
    var propertyType: String?
    var yearBuilt: String?
    var squareFootage: String?
    var affectedAreas: String?
    var severity: String?
    var immediateAction: String?
    var occupancyStatus: String?
    var contactEmail: String?
    var preferredContact: String?
    
    // Relationship
    var claim: Claim?
    
    init(documentPath: String) {
        self.uploadDate = Date()
        self.documentPath = documentPath
        self.extractedText = ""
        self.aiAnalysis = ""
        self.processingStatus = "pending"
    }
}


