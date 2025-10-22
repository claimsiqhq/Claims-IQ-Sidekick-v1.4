//
//  InspectionView.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import SwiftUI

struct InspectionView: View {
    @State private var selectedClaim: Claim?
    @State private var showingPhotoCameraView = false
    @State private var showingLiDARView = false
    @State private var isRecordingLocation = false
    
    var body: some View {
        NavigationStack {
            if selectedClaim == nil {
                claimSelectionView
            } else {
                activeInspectionView
            }
        }
    }
    
    private var claimSelectionView: some View {
        VStack(spacing: Theme.paddingXLarge) {
            Spacer()
            
            Image(systemName: "camera.viewfinder")
                .font(.system(size: 80))
                .foregroundColor(Theme.primary)
            
            VStack(spacing: 12) {
                Text("Start an Inspection")
                    .font(Theme.title)
                    .foregroundColor(Theme.dark)
                
                Text("Select an active claim to begin the inspection process")
                    .font(Theme.callout)
                    .foregroundColor(Theme.dark.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.paddingXLarge)
            }
            
            VStack(spacing: 12) {
                // Sample claims - will be replaced with actual data
                ClaimInspectionCard(
                    claimNumber: "CLM-001234",
                    address: "123 Main St, City, ST",
                    action: {
                        selectedClaim = Claim(
                            claimNumber: "CLM-001234",
                            address: "123 Main St, City, ST 12345",
                            claimType: "Property Damage",
                            policyNumber: "POL-987654",
                            insuredName: "John Doe",
                            contactPhone: "(555) 123-4567",
                            claimDescription: "Water damage",
                            status: "Active"
                        )
                    }
                )
                
                ClaimInspectionCard(
                    claimNumber: "CLM-005678",
                    address: "456 Oak Ave, Town, ST",
                    action: {}
                )
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .background(Theme.neutral3.ignoresSafeArea())
        .navigationTitle("Inspection")
    }
    
    private var activeInspectionView: some View {
        ScrollView {
            VStack(spacing: Theme.paddingLarge) {
                // Active Claim Header
                activeClaimHeader
                
                // Location Tracking Card
                locationTrackingCard
                
                // Capture Options
                captureOptionsSection
                
                // Current Session Stats
                sessionStatsCard
                
                // Recent Photos
                if !recentPhotos.isEmpty {
                    recentPhotosSection
                }
            }
            .padding()
        }
        .background(Theme.neutral3.ignoresSafeArea())
        .navigationTitle("Active Inspection")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("End") {
                    selectedClaim = nil
                }
                .foregroundColor(.red)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Image(systemName: "list.bullet.clipboard")
                        .foregroundColor(Theme.primary)
                }
            }
        }
        .sheet(isPresented: $showingPhotoCameraView) {
            PhotoCaptureView(claim: selectedClaim!)
        }
        .sheet(isPresented: $showingLiDARView) {
            LiDARCaptureView(claim: selectedClaim!)
        }
    }
    
    private var activeClaimHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(selectedClaim?.claimNumber ?? "")
                .font(Theme.headline)
                .foregroundColor(Theme.dark)
            
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(Theme.secondary)
                Text(selectedClaim?.address ?? "")
                    .font(Theme.callout)
                    .foregroundColor(Theme.dark.opacity(0.7))
            }
            
            HStack(spacing: 8) {
                StatusBadge(status: "In Progress")
                
                Spacer()
                
                Text("Started: \(Date().formatted(date: .omitted, time: .shortened))")
                    .font(Theme.caption)
                    .foregroundColor(Theme.dark.opacity(0.6))
            }
        }
        .padding(Theme.paddingLarge)
        .background(Color.white)
        .cornerRadius(Theme.cornerRadiusLarge)
    }
    
    private var locationTrackingCard: some View {
        HStack(spacing: 16) {
            Image(systemName: isRecordingLocation ? "location.fill" : "location")
                .font(.title2)
                .foregroundColor(isRecordingLocation ? .green : Theme.secondary)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Location Tracking")
                    .font(Theme.callout.weight(.semibold))
                    .foregroundColor(Theme.dark)
                
                Text(isRecordingLocation ? "Active - Recording GPS" : "Tap to start tracking")
                    .font(Theme.caption)
                    .foregroundColor(Theme.dark.opacity(0.6))
            }
            
            Spacer()
            
            Toggle("", isOn: $isRecordingLocation)
                .labelsHidden()
                .tint(Theme.primary)
        }
        .padding(Theme.paddingLarge)
        .background(Color.white)
        .cornerRadius(Theme.cornerRadiusLarge)
    }
    
    private var captureOptionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Capture")
                .font(Theme.headline)
                .foregroundColor(Theme.dark)
            
            HStack(spacing: 12) {
                CaptureOptionCard(
                    icon: "camera.fill",
                    title: "Photo",
                    subtitle: "AI Annotated",
                    color: Theme.primary,
                    action: { showingPhotoCameraView = true }
                )
                
                CaptureOptionCard(
                    icon: "light.beacon.max",
                    title: "LiDAR Scan",
                    subtitle: "3D Mapping",
                    color: Theme.accentPrimary,
                    action: { showingLiDARView = true }
                )
            }
        }
    }
    
    private var sessionStatsCard: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Session Stats")
                    .font(Theme.headline)
                    .foregroundColor(Theme.dark)
                Spacer()
            }
            
            HStack(spacing: 0) {
                StatItem(value: "12", label: "Photos", icon: "photo.fill")
                Divider().frame(height: 40)
                StatItem(value: "3", label: "LiDAR Scans", icon: "light.beacon.max")
                Divider().frame(height: 40)
                StatItem(value: "45m", label: "Duration", icon: "clock.fill")
            }
        }
        .padding(Theme.paddingLarge)
        .background(Color.white)
        .cornerRadius(Theme.cornerRadiusLarge)
    }
    
    private var recentPhotos: [String] {
        // Placeholder - will be replaced with actual photos
        ["photo1", "photo2", "photo3"]
    }
    
    private var recentPhotosSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Captures")
                    .font(Theme.headline)
                    .foregroundColor(Theme.dark)
                
                Spacer()
                
                Button("View All") {
                    // Navigate to all photos
                }
                .font(Theme.callout)
                .foregroundColor(Theme.primary)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(0..<5) { index in
                        RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                            .fill(Theme.neutral2)
                            .frame(width: 120, height: 120)
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(Theme.dark.opacity(0.3))
                            )
                    }
                }
            }
        }
    }
}

struct ClaimInspectionCard: View {
    let claimNumber: String
    let address: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(claimNumber)
                        .font(Theme.callout.weight(.semibold))
                        .foregroundColor(Theme.dark)
                    
                    Text(address)
                        .font(Theme.caption)
                        .foregroundColor(Theme.dark.opacity(0.6))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(Theme.secondary)
            }
            .padding(Theme.paddingLarge)
            .background(Color.white)
            .cornerRadius(Theme.cornerRadiusMedium)
        }
    }
}

struct CaptureOptionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 40))
                    .foregroundColor(color)
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(Theme.callout.weight(.semibold))
                        .foregroundColor(Theme.dark)
                    
                    Text(subtitle)
                        .font(Theme.caption)
                        .foregroundColor(Theme.dark.opacity(0.6))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Theme.paddingLarge)
            .background(color.opacity(0.1))
            .cornerRadius(Theme.cornerRadiusLarge)
        }
    }
}

struct StatItem: View {
    let value: String
    let label: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption)
                Text(value)
                    .font(Theme.headline)
            }
            .foregroundColor(Theme.primary)
            
            Text(label)
                .font(Theme.caption)
                .foregroundColor(Theme.dark.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    InspectionView()
}


