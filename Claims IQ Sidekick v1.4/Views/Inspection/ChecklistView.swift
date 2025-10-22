//
//  ChecklistView.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import SwiftUI

struct ChecklistView: View {
    @State private var checklistItems: [ChecklistItemModel] = [
        ChecklistItemModel(title: "Photograph all four sides of property"),
        ChecklistItemModel(title: "Document roof condition"),
        ChecklistItemModel(title: "Inspect foundation and siding"),
        ChecklistItemModel(title: "Check for water damage"),
        ChecklistItemModel(title: "Measure affected areas"),
        ChecklistItemModel(title: "Interview property owner"),
        ChecklistItemModel(title: "Complete LiDAR scan"),
        ChecklistItemModel(title: "Review all photos")
    ]
    
    var completedCount: Int {
        checklistItems.filter { $0.isCompleted }.count
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Progress header
                progressHeader
                
                // Checklist
                List {
                    ForEach($checklistItems) { $item in
                        ChecklistItemRow(item: $item)
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Inspection Checklist")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var progressHeader: some View {
        VStack(spacing: 16) {
            CircularProgressView(
                progress: Double(completedCount) / Double(checklistItems.count),
                color: Theme.primary
            )
            
            Text("\(completedCount) of \(checklistItems.count) completed")
                .font(Theme.callout)
                .foregroundColor(Theme.dark.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct ChecklistItemModel: Identifiable {
    let id = UUID()
    let title: String
    var isCompleted: Bool = false
}

struct ChecklistItemRow: View {
    @Binding var item: ChecklistItemModel
    
    var body: some View {
        Button(action: { item.isCompleted.toggle() }) {
            HStack(spacing: 12) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(item.isCompleted ? .green : Theme.dark.opacity(0.3))
                    .font(.title3)
                
                Text(item.title)
                    .font(Theme.callout)
                    .foregroundColor(Theme.dark)
                    .strikethrough(item.isCompleted)
                
                Spacer()
            }
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    ChecklistView()
}


