//
//  SyncManager.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import Foundation
import Combine

class SyncManager: ObservableObject {
    static let shared = SyncManager()
    
    @Published var isSyncing = false
    @Published var lastSyncDate: Date?
    @Published var pendingOperationsCount = 0
    
    private var pendingOperations: [SyncOperation] = []
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        // Observe network status
        NetworkMonitor.shared.$isConnected
            .sink { [weak self] isConnected in
                if isConnected {
                    Task {
                        await self?.processPendingOperations()
                    }
                }
            }
            .store(in: &cancellables)
        
        // Load last sync date
        if let lastSync = UserDefaults.standard.object(forKey: Constants.lastSyncDateKey) as? Date {
            lastSyncDate = lastSync
        }
    }
    
    func sync() async {
        guard !isSyncing else { return }
        
        await MainActor.run {
            isSyncing = true
        }
        
        // Process all pending operations
        await processPendingOperations()
        
        // Update last sync date
        await MainActor.run {
            lastSyncDate = Date()
            UserDefaults.standard.set(lastSyncDate, forKey: Constants.lastSyncDateKey)
            isSyncing = false
        }
    }
    
    func queueOperation(_ operation: SyncOperation) {
        pendingOperations.append(operation)
        pendingOperationsCount = pendingOperations.count
        
        // If online, process immediately
        if NetworkMonitor.shared.isConnected {
            Task {
                await processPendingOperations()
            }
        }
    }
    
    private func processPendingOperations() async {
        guard !pendingOperations.isEmpty else { return }
        guard NetworkMonitor.shared.isConnected else { return }
        
        var completedOperations: [SyncOperation] = []
        
        for operation in pendingOperations {
            do {
                try await executeOperation(operation)
                completedOperations.append(operation)
            } catch {
                print("Sync operation failed: \(error)")
                // Keep in queue to retry later
            }
        }
        
        // Remove completed operations
        pendingOperations.removeAll { completedOperations.contains($0) }
        
        await MainActor.run {
            pendingOperationsCount = pendingOperations.count
        }
    }
    
    private func executeOperation(_ operation: SyncOperation) async throws {
        switch operation.type {
        case .uploadFNOL:
            // Upload FNOL to server
            break
        case .uploadPhoto:
            // Upload photo to server
            break
        case .uploadLiDARScan:
            // Upload LiDAR scan to server
            break
        case .syncClaim:
            // Sync claim data
            break
        }
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000)
    }
}

struct SyncOperation: Identifiable, Equatable {
    let id = UUID()
    let type: SyncOperationType
    let data: Data?
    let timestamp: Date
    
    static func == (lhs: SyncOperation, rhs: SyncOperation) -> Bool {
        lhs.id == rhs.id
    }
}

enum SyncOperationType {
    case uploadFNOL
    case uploadPhoto
    case uploadLiDARScan
    case syncClaim
}


