//
//  LiDARScan.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import Foundation
import SwiftData

@Model
final class LiDARScan {
    var scanDate: Date
    var scanPath: String // Local file path to scan data
    var thumbnailPath: String?
    var duration: TimeInterval // Scan duration in seconds
    
    // Location data
    var latitude: Double?
    var longitude: Double?
    
    // Scan metadata
    var scanType: String // "room", "exterior", "full_property"
    var areaName: String? // e.g., "Kitchen", "Living Room"
    var pointCount: Int? // Number of points captured
    var fileSize: Int64
    
    // Notes
    var userNotes: String?
    
    // Relationship
    var claim: Claim?
    
    init(scanPath: String, scanType: String, latitude: Double? = nil, longitude: Double? = nil) {
        self.scanDate = Date()
        self.scanPath = scanPath
        self.scanType = scanType
        self.latitude = latitude
        self.longitude = longitude
        self.duration = 0
        self.fileSize = 0
    }
}

