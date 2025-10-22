//
//  LocationService.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import Foundation
import CoreLocation
import Combine

class LocationService: NSObject, ObservableObject {
    static let shared = LocationService()
    
    private let locationManager = CLLocationManager()
    
    @Published var currentLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var isTracking = false
    
    private var locationHistory: [CLLocation] = []
    
    override private init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10 // Update every 10 meters
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startTracking() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            requestPermission()
            return
        }
        
        locationManager.startUpdatingLocation()
        isTracking = true
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
        isTracking = false
    }
    
    func getCurrentLocation() -> CLLocation? {
        return currentLocation
    }
    
    func getLocationHistory() -> [CLLocation] {
        return locationHistory
    }
    
    func clearLocationHistory() {
        locationHistory.removeAll()
    }
    
    // Get distance and ETA to a location
    func getRouteInfo(to destination: CLLocationCoordinate2D) async -> RouteInfo? {
        guard let current = currentLocation else { return nil }
        
        // Calculate straight-line distance
        let destLocation = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        let distance = current.distance(from: destLocation)
        
        // Simple ETA calculation (assuming 30 mph average)
        let milesPerMeter = 0.000621371
        let distanceMiles = distance * milesPerMeter
        let hoursAtSpeed = distanceMiles / 30.0
        let minutes = Int(hoursAtSpeed * 60)
        
        return RouteInfo(
            distance: distanceMiles,
            eta: minutes,
            distanceFormatted: String(format: "%.1f miles", distanceMiles),
            etaFormatted: "\(minutes) min"
        )
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        currentLocation = location
        
        // Add to history if tracking
        if isTracking {
            locationHistory.append(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
}

struct RouteInfo {
    let distance: Double // in miles
    let eta: Int // in minutes
    let distanceFormatted: String
    let etaFormatted: String
}

