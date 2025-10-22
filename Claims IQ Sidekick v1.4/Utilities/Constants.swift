//
//  Constants.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import Foundation

struct Constants {
    // MARK: - API Keys
    
    static let openAIAPIKeyDefault = "OPENAI_API_KEY_PLACEHOLDER"
    
    // MARK: - UserDefaults Keys
    
    static let openAIAPIKeyKey = "openai_api_key"
    static let lastSyncDateKey = "last_sync_date"
    static let offlineModeKey = "offline_mode"
    
    // MARK: - App Info
    
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.4"
    static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    
    // MARK: - OpenAI Configuration
    
    static let openAIBaseURL = "https://api.openai.com/v1"
    static let gptModel = "gpt-4o"
    static let visionModel = "gpt-4o"
    static let maxTokens = 2000
    
    // MARK: - File Storage
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let photosDirectory = documentsDirectory.appendingPathComponent("Photos")
    static let fnolDirectory = documentsDirectory.appendingPathComponent("FNOLs")
    static let lidarDirectory = documentsDirectory.appendingPathComponent("LiDAR")
}

