//
//  Photo.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import Foundation
import SwiftData

@Model
final class Photo {
    var captureDate: Date
    var imagePath: String // Local file path
    var thumbnailPath: String?
    
    // Location data
    var latitude: Double?
    var longitude: Double?
    var locationAccuracy: Double?
    
    // AI Annotations
    var aiAnnotations: String? // JSON string of annotations
    var hasAIAnalysis: Bool
    var aiProcessingStatus: String // "pending", "processing", "completed", "failed"
    
    // Manual data
    var userNotes: String?
    var tags: String? // Comma-separated tags
    
    // Metadata
    var fileSize: Int64
    var imageWidth: Int
    var imageHeight: Int
    
    // Relationship
    var claim: Claim?
    
    init(imagePath: String, latitude: Double? = nil, longitude: Double? = nil) {
        self.captureDate = Date()
        self.imagePath = imagePath
        self.latitude = latitude
        self.longitude = longitude
        self.hasAIAnalysis = false
        self.aiProcessingStatus = "pending"
        self.fileSize = 0
        self.imageWidth = 0
        self.imageHeight = 0
    }
}


