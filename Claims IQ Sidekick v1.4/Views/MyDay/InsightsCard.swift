//
//  InsightsCard.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import SwiftUI

struct InsightsCard: View {
    @Binding var isLoading: Bool
    @State private var insights: [String] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.paddingMedium) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(Theme.accentPrimary)
                Text("AI Insights")
                    .font(Theme.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: refreshInsights) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.white)
                }
            }
            
            if isLoading {
                ProgressView()
                    .tint(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else if insights.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.7))
                    Text("Tap refresh to get AI-powered insights for your day")
                        .font(Theme.callout)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(insights, id: \.self) { insight in
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Theme.accentPrimary)
                            Text(insight)
                                .font(Theme.callout)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
        .padding(Theme.paddingLarge)
        .background(Theme.primaryGradient)
        .cornerRadius(Theme.cornerRadiusLarge)
        .shadow(color: Theme.primary.opacity(0.3), radius: 10, x: 0, y: 5)
    }
    
    private func refreshInsights() {
        isLoading = true
        
        // Placeholder - will be replaced with actual OpenAI call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            insights = [
                "Start with Claim #1234 - it's on your route",
                "Weather alert: Rain expected at 2 PM",
                "3 claims ready for final review"
            ]
            isLoading = false
        }
    }
}

#Preview {
    InsightsCard(isLoading: .constant(false))
        .padding()
}

