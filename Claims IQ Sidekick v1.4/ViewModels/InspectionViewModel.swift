//
//  InspectionViewModel.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import Foundation
import SwiftData
import UIKit
import CoreLocation

@MainActor
class InspectionViewModel: ObservableObject {
    @Published var isProcessingPhoto = false
    @Published var capturedPhotos: [Photo] = []
    @Published var currentAnnotations: [String] = []
    @Published var error: Error?
    
    @Published var isLocationTracking = false
    @Published var currentLocation: CLLocation?
    
    private let openAIService = OpenAIService.shared
    private let storageService = StorageService.shared
    private let locationService = LocationService.shared
    private let syncManager = SyncManager.shared
    
    func startLocationTracking() {
        locationService.startTracking()
        isLocationTracking = true
    }
    
    func stopLocationTracking() {
        locationService.stopTracking()
        isLocationTracking = false
    }
    
    func captureAndAnnotatePhoto(
        image: UIImage,
        claim: Claim,
        modelContext: ModelContext
    ) async -> Photo? {
        isProcessingPhoto = true
        error = nil
        currentAnnotations = []
        
        do {
            // Save photo to storage
            guard let imagePath = storageService.savePhoto(image, for: claim.claimNumber) else {
                throw NSError(domain: "Storage", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to save photo"])
            }
            
            // Get current location
            let location = locationService.currentLocation
            
            // Create photo model
            let photo = Photo(
                imagePath: imagePath,
                latitude: location?.coordinate.latitude,
                longitude: location?.coordinate.longitude
            )
            
            // Set metadata
            photo.imageWidth = Int(image.size.width)
            photo.imageHeight = Int(image.size.height)
            photo.fileSize = Int64(image.jpegData(compressionQuality: 0.8)?.count ?? 0)
            
            // Process with AI for annotations
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                photo.aiProcessingStatus = "processing"
                
                let result = try await openAIService.annotatePhoto(imageData: imageData)
                
                // Convert annotations to JSON
                if let jsonData = try? JSONEncoder().encode(result.annotations),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    photo.aiAnnotations = jsonString
                }
                
                photo.hasAIAnalysis = true
                photo.aiProcessingStatus = "completed"
                currentAnnotations = result.annotations
            }
            
            // Link to claim
            photo.claim = claim
            claim.photos.append(photo)
            claim.hasPhotos = true
            
            // Save to database
            modelContext.insert(photo)
            try modelContext.save()
            
            // Queue for sync if offline
            if !NetworkMonitor.shared.isConnected,
               let imageData = image.jpegData(compressionQuality: 0.8) {
                syncManager.queueOperation(SyncOperation(
                    type: .uploadPhoto,
                    data: imageData,
                    timestamp: Date()
                ))
            }
            
            capturedPhotos.append(photo)
            isProcessingPhoto = false
            
            return photo
            
        } catch {
            self.error = error
            isProcessingPhoto = false
            return nil
        }
    }
    
    func saveLiDARScan(
        scanData: Data,
        scanType: String,
        claim: Claim,
        modelContext: ModelContext
    ) async -> LiDARScan? {
        do {
            // Save scan to storage
            guard let scanPath = storageService.saveLiDARScan(scanData, for: claim.claimNumber) else {
                throw NSError(domain: "Storage", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to save LiDAR scan"])
            }
            
            // Get current location
            let location = locationService.currentLocation
            
            // Create LiDAR scan model
            let scan = LiDARScan(
                scanPath: scanPath,
                scanType: scanType,
                latitude: location?.coordinate.latitude,
                longitude: location?.coordinate.longitude
            )
            
            scan.fileSize = Int64(scanData.count)
            
            // Link to claim
            scan.claim = claim
            claim.lidarScans.append(scan)
            claim.hasLiDARScans = true
            
            // Save to database
            modelContext.insert(scan)
            try modelContext.save()
            
            // Queue for sync if offline
            if !NetworkMonitor.shared.isConnected {
                syncManager.queueOperation(SyncOperation(
                    type: .uploadLiDARScan,
                    data: scanData,
                    timestamp: Date()
                ))
            }
            
            return scan
            
        } catch {
            self.error = error
            return nil
        }
    }
}


