//
//  Claim.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import Foundation
import SwiftData

@Model
final class Claim {
    var claimNumber: String
    var address: String
    var claimType: String
    var policyNumber: String
    var insuredName: String
    var contactPhone: String
    var claimDescription: String
    var status: String // "Active", "Pending", "Completed"
    var createdDate: Date
    var lastModifiedDate: Date
    
    // Location
    var latitude: Double?
    var longitude: Double?
    
    // Flags
    var hasFNOL: Bool
    var hasWorkflow: Bool
    var hasPhotos: Bool
    var hasLiDARScans: Bool
    
    // Relationships
    @Relationship(deleteRule: .cascade) var fnol: FNOL?
    @Relationship(deleteRule: .cascade) var workflow: InspectionWorkflow?
    @Relationship(deleteRule: .cascade) var photos: [Photo] = []
    @Relationship(deleteRule: .cascade) var lidarScans: [LiDARScan] = []
    
    init(
        claimNumber: String,
        address: String,
        claimType: String,
        policyNumber: String,
        insuredName: String,
        contactPhone: String,
        claimDescription: String,
        status: String,
        latitude: Double? = nil,
        longitude: Double? = nil
    ) {
        self.claimNumber = claimNumber
        self.address = address
        self.claimType = claimType
        self.policyNumber = policyNumber
        self.insuredName = insuredName
        self.contactPhone = contactPhone
        self.claimDescription = claimDescription
        self.status = status
        self.createdDate = Date()
        self.lastModifiedDate = Date()
        self.latitude = latitude
        self.longitude = longitude
        self.hasFNOL = false
        self.hasWorkflow = false
        self.hasPhotos = false
        self.hasLiDARScans = false
    }
}


