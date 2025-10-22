//
//  ClaimDetailView.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import SwiftUI

struct ClaimDetailView: View {
    let claim: Claim
    @State private var selectedTab = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: Theme.paddingLarge) {
                // Claim Header
                claimHeaderSection
                
                // Tab Selector
                Picker("View", selection: $selectedTab) {
                    Text("Details").tag(0)
                    Text("FNOL").tag(1)
                    Text("Workflow").tag(2)
                    Text("Photos").tag(3)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Content based on selected tab
                Group {
                    switch selectedTab {
                    case 0:
                        detailsSection
                    case 1:
                        fnolSection
                    case 2:
                        workflowSection
                    case 3:
                        photosSection
                    default:
                        EmptyView()
                    }
                }
            }
            .padding(.vertical)
        }
        .background(Theme.neutral3.ignoresSafeArea())
        .navigationTitle(claim.claimNumber)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var claimHeaderSection: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(claim.claimNumber)
                        .font(Theme.title)
                        .foregroundColor(Theme.dark)
                    
                    HStack {
                        Image(systemName: "location.fill")
                        Text(claim.address)
                    }
                    .font(Theme.callout)
                    .foregroundColor(Theme.dark.opacity(0.7))
                }
                
                Spacer()
                
                StatusBadge(status: claim.status)
            }
            
            // Action Buttons
            HStack(spacing: 12) {
                ActionButton(icon: "map.fill", title: "Directions", color: Theme.primary) {
                    // Open directions
                }
                
                ActionButton(icon: "phone.fill", title: "Call", color: Theme.accentPrimary) {
                    // Make call
                }
                
                ActionButton(icon: "square.and.arrow.up", title: "Share", color: Theme.secondary) {
                    // Share claim
                }
            }
        }
        .padding(Theme.paddingLarge)
        .background(Color.white)
        .cornerRadius(Theme.cornerRadiusLarge)
        .padding(.horizontal)
    }
    
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            DetailRow(label: "Claim Type", value: claim.claimType)
            DetailRow(label: "Date Reported", value: claim.createdDate.formatted(date: .long, time: .omitted))
            DetailRow(label: "Policy Number", value: claim.policyNumber)
            DetailRow(label: "Insured Name", value: claim.insuredName)
            DetailRow(label: "Contact Phone", value: claim.contactPhone)
            DetailRow(label: "Description", value: claim.claimDescription)
        }
        .padding(Theme.paddingLarge)
        .background(Color.white)
        .cornerRadius(Theme.cornerRadiusLarge)
        .padding(.horizontal)
    }
    
    private var fnolSection: some View {
        VStack(spacing: 16) {
            if claim.hasFNOL {
                FNOLDisplayView(claim: claim)
            } else {
                EmptyStateCard(
                    icon: "doc.text",
                    title: "No FNOL Uploaded",
                    subtitle: "Upload a First Notice of Loss document",
                    actionTitle: "Upload FNOL",
                    action: {}
                )
            }
        }
        .padding(.horizontal)
    }
    
    private var workflowSection: some View {
        VStack(spacing: 16) {
            if claim.hasWorkflow {
                WorkflowView(claim: claim)
            } else {
                EmptyStateCard(
                    icon: "list.bullet.clipboard",
                    title: "No Workflow Generated",
                    subtitle: "Generate an AI-powered inspection workflow",
                    actionTitle: "Generate Workflow",
                    action: {}
                )
            }
        }
        .padding(.horizontal)
    }
    
    private var photosSection: some View {
        VStack(spacing: 16) {
            if claim.hasPhotos {
                PhotosGridView(claim: claim)
            } else {
                EmptyStateCard(
                    icon: "camera",
                    title: "No Photos",
                    subtitle: "Start capturing inspection photos",
                    actionTitle: "Take Photo",
                    action: {}
                )
            }
        }
        .padding(.horizontal)
    }
}

struct ActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .font(Theme.caption)
            }
            .foregroundColor(color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(color.opacity(0.1))
            .cornerRadius(Theme.cornerRadiusMedium)
        }
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(Theme.caption)
                .foregroundColor(Theme.dark.opacity(0.6))
            Text(value)
                .font(Theme.callout)
                .foregroundColor(Theme.dark)
        }
    }
}

struct EmptyStateCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let actionTitle: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundColor(Theme.secondary)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(Theme.headline)
                    .foregroundColor(Theme.dark)
                
                Text(subtitle)
                    .font(Theme.callout)
                    .foregroundColor(Theme.dark.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
            
            Button(action: action) {
                Text(actionTitle)
                    .font(Theme.callout.weight(.semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Theme.primaryGradient)
                    .cornerRadius(Theme.cornerRadiusMedium)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(Theme.paddingXLarge)
        .background(Color.white)
        .cornerRadius(Theme.cornerRadiusLarge)
    }
}

// Placeholder views for sections
struct PhotosGridView: View {
    let claim: Claim
    
    var body: some View {
        Text("Photos Grid - To be implemented")
            .padding()
            .background(Color.white)
            .cornerRadius(Theme.cornerRadiusMedium)
    }
}

#Preview {
    NavigationStack {
        ClaimDetailView(claim: Claim(
            claimNumber: "CLM-001234",
            address: "123 Main St, City, ST 12345",
            claimType: "Property Damage",
            policyNumber: "POL-987654",
            insuredName: "John Doe",
            contactPhone: "(555) 123-4567",
            claimDescription: "Water damage from burst pipe",
            status: "Active"
        ))
    }
}


