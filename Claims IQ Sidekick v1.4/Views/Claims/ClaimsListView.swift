//
//  ClaimsListView.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import SwiftUI
import SwiftData

struct ClaimsListView: View {
    @Query private var claims: [Claim]
    @State private var searchText = ""
    @State private var selectedFilter: ClaimFilter = .all
    @State private var showingNewClaim = false
    
    enum ClaimFilter: String, CaseIterable {
        case all = "All"
        case active = "Active"
        case pending = "Pending"
        case completed = "Completed"
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filter Pills
                filterSection
                
                // Claims List
                if filteredClaims.isEmpty {
                    emptyStateView
                } else {
                    List {
                        ForEach(filteredClaims) { claim in
                            NavigationLink(destination: ClaimDetailView(claim: claim)) {
                                ClaimRowView(claim: claim)
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        // Refresh claims
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search claims...")
            .navigationTitle("Claims")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewClaim = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Theme.primary)
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showingNewClaim) {
                FNOLUploadView()
            }
        }
    }
    
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ClaimFilter.allCases, id: \.self) { filter in
                    FilterPill(
                        title: filter.rawValue,
                        isSelected: selectedFilter == filter,
                        action: { selectedFilter = filter }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .background(Theme.neutral3)
    }
    
    private var filteredClaims: [Claim] {
        var result = claims
        
        // Filter by status
        if selectedFilter != .all {
            result = result.filter { $0.status.lowercased() == selectedFilter.rawValue.lowercased() }
        }
        
        // Filter by search
        if !searchText.isEmpty {
            result = result.filter {
                $0.claimNumber.localizedCaseInsensitiveContains(searchText) ||
                $0.address.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(Theme.secondary)
            
            Text("No Claims Found")
                .font(Theme.headline)
                .foregroundColor(Theme.dark)
            
            Text("Upload a FNOL to get started")
                .font(Theme.callout)
                .foregroundColor(Theme.dark.opacity(0.6))
            
            Button(action: { showingNewClaim = true }) {
                Text("Upload FNOL")
                    .font(Theme.callout.weight(.semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Theme.primaryGradient)
                    .cornerRadius(Theme.cornerRadiusMedium)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.neutral3)
    }
}

struct FilterPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(Theme.callout.weight(isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .white : Theme.dark)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(isSelected ? Theme.primaryGradient : LinearGradient(colors: [Color.white], startPoint: .top, endPoint: .bottom))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
}

struct ClaimRowView: View {
    let claim: Claim
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(claim.claimNumber)
                    .font(Theme.headline)
                    .foregroundColor(Theme.dark)
                
                Spacer()
                
                StatusBadge(status: claim.status)
            }
            
            HStack {
                Image(systemName: "location.fill")
                    .font(.caption)
                    .foregroundColor(Theme.secondary)
                Text(claim.address)
                    .font(Theme.callout)
                    .foregroundColor(Theme.dark.opacity(0.8))
                    .lineLimit(1)
            }
            
            HStack {
                Image(systemName: "calendar")
                    .font(.caption)
                    .foregroundColor(Theme.secondary)
                Text(claim.createdDate, style: .date)
                    .font(Theme.caption)
                    .foregroundColor(Theme.dark.opacity(0.6))
                
                Spacer()
                
                if claim.hasPhotos {
                    Image(systemName: "photo.fill")
                        .font(.caption)
                        .foregroundColor(Theme.accentPrimary)
                }
                
                if claim.hasFNOL {
                    Image(systemName: "doc.fill")
                        .font(.caption)
                        .foregroundColor(Theme.primary)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct StatusBadge: View {
    let status: String
    
    private var statusColor: Color {
        switch status.lowercased() {
        case "active": return .green
        case "pending": return Theme.accentPrimary
        case "completed": return .blue
        default: return Theme.secondary
        }
    }
    
    var body: some View {
        Text(status)
            .font(Theme.caption.weight(.semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(statusColor)
            .cornerRadius(12)
    }
}

#Preview {
    ClaimsListView()
        .modelContainer(for: Claim.self, inMemory: true)
}

