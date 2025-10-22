//
//  ClaimRouteCard.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import SwiftUI

struct ClaimRouteCard: View {
    let claimNumber: String
    let address: String
    let distance: String
    let eta: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(claimNumber)
                    .font(Theme.headline)
                    .foregroundColor(Theme.dark)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.caption)
                        .foregroundColor(Theme.primary)
                    Text(distance)
                        .font(Theme.caption)
                        .foregroundColor(Theme.dark.opacity(0.7))
                }
            }
            
            Text(address)
                .font(Theme.callout)
                .foregroundColor(Theme.dark.opacity(0.8))
                .lineLimit(2)
            
            HStack(spacing: Theme.paddingMedium) {
                Button(action: {
                    // Open in Maps
                }) {
                    HStack {
                        Image(systemName: "map.fill")
                        Text("Directions")
                    }
                    .font(Theme.callout)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Theme.primaryGradient)
                    .cornerRadius(Theme.cornerRadiusMedium)
                }
                
                VStack(spacing: 4) {
                    Text("ETA")
                        .font(Theme.caption)
                        .foregroundColor(Theme.dark.opacity(0.6))
                    Text(eta)
                        .font(Theme.callout.weight(.semibold))
                        .foregroundColor(Theme.accentPrimary)
                }
                .frame(width: 70)
            }
        }
        .padding(Theme.paddingMedium)
        .background(Color.white)
        .cornerRadius(Theme.cornerRadiusMedium)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    ClaimRouteCard(
        claimNumber: "CLM-001234",
        address: "123 Main St, City, ST 12345",
        distance: "2.3 miles",
        eta: "15 min"
    )
    .padding()
}

