//
//  SettingsViewModel.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import Foundation
import Combine

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var storageUsage: StorageUsage
    @Published var isSyncing = false
    @Published var lastSyncDate: Date?
    
    private let storageService = StorageService.shared
    private let syncManager = SyncManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.storageUsage = storageService.getStorageUsage()
        self.lastSyncDate = syncManager.lastSyncDate
        
        // Observe sync manager
        syncManager.$isSyncing
            .assign(to: &$isSyncing)
        
        syncManager.$lastSyncDate
            .assign(to: &$lastSyncDate)
    }
    
    func refreshStorageUsage() {
        storageUsage = storageService.getStorageUsage()
    }
    
    func performSync() async {
        await syncManager.sync()
    }
    
    func clearCache() {
        storageService.clearCache()
        refreshStorageUsage()
    }
}


