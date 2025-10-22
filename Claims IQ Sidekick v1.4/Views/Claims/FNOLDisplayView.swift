//
//  FNOLDisplayView.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import SwiftUI

struct FNOLDisplayView: View {
    let claim: Claim
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.paddingLarge) {
            // FNOL Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("FNOL Data")
                        .font(Theme.headline)
                        .foregroundColor(Theme.dark)
                    
                    Text("Extracted by AI on \(Date().formatted(date: .abbreviated, time: .shortened))")
                        .font(Theme.caption)
                        .foregroundColor(Theme.dark.opacity(0.6))
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.down")
                        .foregroundColor(Theme.primary)
                }
            }
            
            // Extracted Sections
            VStack(spacing: 16) {
                FNOLSection(
                    title: "Incident Details",
                    items: [
                        ("Date of Loss", "October 15, 2025"),
                        ("Time of Loss", "2:30 PM"),
                        ("Type of Loss", "Water Damage"),
                        ("Cause", "Burst Pipe")
                    ]
                )
                
                FNOLSection(
                    title: "Property Information",
                    items: [
                        ("Address", claim.address),
                        ("Property Type", "Single Family Home"),
                        ("Year Built", "1998"),
                        ("Square Footage", "2,400 sq ft")
                    ]
                )
                
                FNOLSection(
                    title: "Damage Assessment",
                    items: [
                        ("Affected Areas", "Kitchen, Living Room"),
                        ("Estimated Severity", "Moderate"),
                        ("Immediate Action Taken", "Water shut off, fans deployed"),
                        ("Occupancy Status", "Occupied")
                    ]
                )
                
                FNOLSection(
                    title: "Contact Information",
                    items: [
                        ("Insured Name", claim.insuredName),
                        ("Phone", claim.contactPhone),
                        ("Email", "insured@email.com"),
                        ("Preferred Contact", "Phone")
                    ]
                )
            }
            
            // Generate Workflow Button
            Button(action: {}) {
                HStack {
                    Image(systemName: "sparkles")
                    Text("Generate Inspection Workflow")
                        .font(Theme.callout.weight(.semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Theme.accentGradient)
                .cornerRadius(Theme.cornerRadiusMedium)
            }
        }
        .padding(Theme.paddingLarge)
        .background(Color.white)
        .cornerRadius(Theme.cornerRadiusLarge)
    }
}

struct FNOLSection: View {
    let title: String
    let items: [(String, String)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(Theme.callout.weight(.semibold))
                .foregroundColor(Theme.primary)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(items, id: \.0) { item in
                    HStack(alignment: .top) {
                        Text(item.0 + ":")
                            .font(Theme.caption)
                            .foregroundColor(Theme.dark.opacity(0.6))
                            .frame(width: 130, alignment: .leading)
                        
                        Text(item.1)
                            .font(Theme.callout)
                            .foregroundColor(Theme.dark)
                        
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(Theme.neutral1)
        .cornerRadius(Theme.cornerRadiusMedium)
    }
}

#Preview {
    FNOLDisplayView(claim: Claim(
        claimNumber: "CLM-001234",
        address: "123 Main St, City, ST 12345",
        claimType: "Property Damage",
        policyNumber: "POL-987654",
        insuredName: "John Doe",
        contactPhone: "(555) 123-4567",
        claimDescription: "Water damage from burst pipe",
        status: "Active"
    ))
    .padding()
}

