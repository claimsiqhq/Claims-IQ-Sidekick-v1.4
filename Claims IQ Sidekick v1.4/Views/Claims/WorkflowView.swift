//
//  WorkflowView.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import SwiftUI

struct WorkflowView: View {
    let claim: Claim
    @State private var completedSteps: Set<String> = []
    
    // Sample workflow steps - will be AI-generated
    private let workflowSteps = [
        WorkflowStep(id: "1", title: "Exterior Inspection", items: [
            "Photograph all four sides of property",
            "Document roof condition",
            "Check gutters and downspouts",
            "Inspect siding and foundation"
        ]),
        WorkflowStep(id: "2", title: "Interior - Kitchen", items: [
            "Document water damage extent",
            "Photograph affected cabinets",
            "Check flooring condition",
            "Inspect ceiling for water stains"
        ]),
        WorkflowStep(id: "3", title: "Interior - Living Room", items: [
            "Document carpet/flooring damage",
            "Check baseboards and walls",
            "Photograph affected furniture",
            "Measure affected area"
        ]),
        WorkflowStep(id: "4", title: "Plumbing Assessment", items: [
            "Locate burst pipe",
            "Document repair work needed",
            "Check for additional vulnerabilities",
            "Photograph plumbing system"
        ]),
        WorkflowStep(id: "5", title: "Final Documentation", items: [
            "Complete LiDAR scan of affected areas",
            "Take overview photos",
            "Interview property owner",
            "Document temporary repairs"
        ])
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.paddingLarge) {
            // Workflow Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Inspection Workflow")
                        .font(Theme.headline)
                        .foregroundColor(Theme.dark)
                    
                    Text("AI-generated based on FNOL analysis")
                        .font(Theme.caption)
                        .foregroundColor(Theme.dark.opacity(0.6))
                }
                
                Spacer()
                
                // Progress indicator
                CircularProgressView(
                    progress: Double(completedSteps.count) / Double(totalItems),
                    color: Theme.accentPrimary
                )
            }
            
            // Workflow Steps
            VStack(spacing: 16) {
                ForEach(workflowSteps) { step in
                    WorkflowStepCard(
                        step: step,
                        completedSteps: $completedSteps
                    )
                }
            }
            
            // Action Button
            Button(action: {}) {
                HStack {
                    Image(systemName: "camera.fill")
                    Text("Start Inspection")
                        .font(Theme.callout.weight(.semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Theme.primaryGradient)
                .cornerRadius(Theme.cornerRadiusMedium)
            }
        }
        .padding(Theme.paddingLarge)
        .background(Color.white)
        .cornerRadius(Theme.cornerRadiusLarge)
    }
    
    private var totalItems: Int {
        workflowSteps.reduce(0) { $0 + $1.items.count }
    }
}

struct WorkflowStep: Identifiable {
    let id: String
    let title: String
    let items: [String]
}

struct WorkflowStepCard: View {
    let step: WorkflowStep
    @Binding var completedSteps: Set<String>
    @State private var isExpanded = false
    
    private var completedCount: Int {
        step.items.filter { completedSteps.contains(step.id + $0) }.count
    }
    
    private var isComplete: Bool {
        completedCount == step.items.count
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Step header
            Button(action: { withAnimation { isExpanded.toggle() } }) {
                HStack {
                    Image(systemName: isComplete ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isComplete ? .green : Theme.secondary)
                        .font(.title3)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(step.title)
                            .font(Theme.callout.weight(.semibold))
                            .foregroundColor(Theme.dark)
                        
                        Text("\(completedCount)/\(step.items.count) completed")
                            .font(Theme.caption)
                            .foregroundColor(Theme.dark.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(Theme.secondary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
            }
            
            // Step items
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(step.items, id: \.self) { item in
                        ChecklistItem(
                            title: item,
                            isCompleted: completedSteps.contains(step.id + item),
                            onToggle: {
                                if completedSteps.contains(step.id + item) {
                                    completedSteps.remove(step.id + item)
                                } else {
                                    completedSteps.insert(step.id + item)
                                }
                            }
                        )
                    }
                }
                .padding(.leading, 32)
            }
        }
        .padding()
        .background(Theme.neutral1)
        .cornerRadius(Theme.cornerRadiusMedium)
    }
}

struct ChecklistItem: View {
    let title: String
    let isCompleted: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 12) {
                Image(systemName: isCompleted ? "checkmark.square.fill" : "square")
                    .foregroundColor(isCompleted ? Theme.primary : Theme.dark.opacity(0.3))
                
                Text(title)
                    .font(Theme.callout)
                    .foregroundColor(Theme.dark)
                    .strikethrough(isCompleted)
                
                Spacer()
            }
        }
    }
}

struct CircularProgressView: View {
    let progress: Double
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 4)
                .frame(width: 50, height: 50)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: 50, height: 50)
                .rotationEffect(.degrees(-90))
            
            Text("\(Int(progress * 100))%")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Theme.dark)
        }
    }
}

#Preview {
    WorkflowView(claim: Claim(
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

