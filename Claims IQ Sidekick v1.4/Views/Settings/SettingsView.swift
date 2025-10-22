//
//  SettingsView.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("openai_api_key") private var apiKey: String = ""
    @AppStorage("auto_location_tracking") private var autoLocationTracking = true
    @AppStorage("auto_ai_annotation") private var autoAIAnnotation = true
    @AppStorage("high_quality_photos") private var highQualityPhotos = true
    @AppStorage("offline_mode") private var offlineMode = false
    
    @State private var showingAPIKeySheet = false
    @State private var lastSyncDate = Date()
    @State private var showingAbout = false
    
    var body: some View {
        NavigationStack {
            List {
                // OpenAI Configuration
                Section {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("OpenAI API Key")
                                .font(Theme.callout)
                                .foregroundColor(Theme.dark)
                            
                            Text(apiKey.isEmpty ? "Not configured" : "••••••••" + apiKey.suffix(4))
                                .font(Theme.caption)
                                .foregroundColor(Theme.dark.opacity(0.6))
                        }
                        
                        Spacer()
                        
                        Button(action: { showingAPIKeySheet = true }) {
                            Text(apiKey.isEmpty ? "Add" : "Edit")
                                .foregroundColor(Theme.primary)
                        }
                    }
                    
                    if !apiKey.isEmpty {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("API Key configured")
                                .font(Theme.callout)
                                .foregroundColor(Theme.dark)
                        }
                    }
                } header: {
                    Text("AI Configuration")
                } footer: {
                    Text("Your OpenAI API key is stored securely on your device and used for FNOL parsing, photo annotation, and insights generation.")
                }
                
                // App Preferences
                Section("Preferences") {
                    Toggle(isOn: $autoLocationTracking) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Auto Location Tracking")
                                .font(Theme.callout)
                            Text("Automatically track GPS during inspections")
                                .font(Theme.caption)
                                .foregroundColor(Theme.dark.opacity(0.6))
                        }
                    }
                    .tint(Theme.primary)
                    
                    Toggle(isOn: $autoAIAnnotation) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Auto AI Annotation")
                                .font(Theme.callout)
                            Text("Automatically annotate photos with AI")
                                .font(Theme.caption)
                                .foregroundColor(Theme.dark.opacity(0.6))
                        }
                    }
                    .tint(Theme.primary)
                    
                    Toggle(isOn: $highQualityPhotos) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("High Quality Photos")
                                .font(Theme.callout)
                            Text("Capture photos at maximum resolution")
                                .font(Theme.caption)
                                .foregroundColor(Theme.dark.opacity(0.6))
                        }
                    }
                    .tint(Theme.primary)
                }
                
                // Sync & Storage
                Section {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Offline Mode")
                                .font(Theme.callout)
                            Text(offlineMode ? "Working offline" : "Online")
                                .font(Theme.caption)
                                .foregroundColor(offlineMode ? .orange : .green)
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: $offlineMode)
                            .labelsHidden()
                            .tint(Theme.primary)
                    }
                    
                    HStack {
                        Text("Last Sync")
                            .font(Theme.callout)
                        
                        Spacer()
                        
                        Text(lastSyncDate.formatted(date: .abbreviated, time: .shortened))
                            .font(Theme.caption)
                            .foregroundColor(Theme.dark.opacity(0.6))
                    }
                    
                    Button(action: performSync) {
                        HStack {
                            Image(systemName: "arrow.triangle.2.circlepath")
                            Text("Sync Now")
                        }
                        .foregroundColor(Theme.primary)
                    }
                    
                    NavigationLink(destination: StorageManagementView()) {
                        HStack {
                            Text("Storage Management")
                                .font(Theme.callout)
                            
                            Spacer()
                            
                            Text("2.3 GB")
                                .font(Theme.caption)
                                .foregroundColor(Theme.dark.opacity(0.6))
                        }
                    }
                } header: {
                    Text("Sync & Storage")
                }
                
                // Account
                Section("Account") {
                    HStack {
                        Text("User")
                        Spacer()
                        Text("John Shoust")
                            .foregroundColor(Theme.dark.opacity(0.6))
                    }
                    
                    HStack {
                        Text("Email")
                        Spacer()
                        Text("john.shoust@pm.me")
                            .foregroundColor(Theme.dark.opacity(0.6))
                    }
                    
                    Button("Sign Out") {
                        // Sign out action
                    }
                    .foregroundColor(.red)
                }
                
                // About
                Section {
                    Button(action: { showingAbout = true }) {
                        HStack {
                            Text("About Claims IQ Sidekick")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(Theme.dark.opacity(0.3))
                        }
                        .foregroundColor(Theme.dark)
                    }
                    
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Constants.appVersion)
                            .foregroundColor(Theme.dark.opacity(0.6))
                    }
                    
                    Link(destination: URL(string: "https://support.example.com")!) {
                        HStack {
                            Text("Support & Help")
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                        }
                    }
                    
                    Link(destination: URL(string: "https://privacy.example.com")!) {
                        HStack {
                            Text("Privacy Policy")
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingAPIKeySheet) {
                APIKeyConfigSheet(apiKey: $apiKey)
            }
            .sheet(isPresented: $showingAbout) {
                AboutView()
            }
        }
    }
    
    private func performSync() {
        // Perform sync operation
        lastSyncDate = Date()
    }
}

struct APIKeyConfigSheet: View {
    @Binding var apiKey: String
    @State private var tempApiKey: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("OpenAI API Key")
                        .font(Theme.headline)
                        .foregroundColor(Theme.dark)
                    
                    Text("Enter your OpenAI API key to enable AI-powered features including FNOL parsing, photo annotation, and daily insights.")
                        .font(Theme.callout)
                        .foregroundColor(Theme.dark.opacity(0.7))
                }
                
                SecureField("sk-...", text: $tempApiKey)
                    .textFieldStyle(.roundedBorder)
                    .font(Theme.body)
                
                VStack(alignment: .leading, spacing: 12) {
                    InfoRow(
                        icon: "lock.fill",
                        text: "Your API key is stored securely on device"
                    )
                    
                    InfoRow(
                        icon: "network",
                        text: "Only sent to OpenAI servers for processing"
                    )
                    
                    InfoRow(
                        icon: "key.fill",
                        text: "Get your API key from platform.openai.com"
                    )
                }
                .padding()
                .background(Theme.neutral1)
                .cornerRadius(Theme.cornerRadiusMedium)
                
                Spacer()
            }
            .padding()
            .navigationTitle("API Configuration")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        apiKey = tempApiKey
                        dismiss()
                    }
                    .disabled(tempApiKey.isEmpty)
                }
            }
            .onAppear {
                tempApiKey = apiKey
            }
        }
    }
}

struct InfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(Theme.primary)
                .frame(width: 20)
            
            Text(text)
                .font(Theme.callout)
                .foregroundColor(Theme.dark)
        }
    }
}

struct StorageManagementView: View {
    var body: some View {
        List {
            Section("Storage Usage") {
                StorageItem(label: "Photos", size: "1.8 GB")
                StorageItem(label: "LiDAR Scans", size: "400 MB")
                StorageItem(label: "FNOL Documents", size: "85 MB")
                StorageItem(label: "Cache", size: "45 MB")
            }
            
            Section {
                Button("Clear Cache") {
                    // Clear cache
                }
                .foregroundColor(Theme.primary)
                
                Button("Delete Offline Data") {
                    // Delete offline data
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("Storage")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StorageItem: View {
    let label: String
    let size: String
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(size)
                .foregroundColor(Theme.dark.opacity(0.6))
        }
    }
}

struct AboutView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()
                
                // App Icon placeholder
                RoundedRectangle(cornerRadius: 20)
                    .fill(Theme.primaryGradient)
                    .frame(width: 120, height: 120)
                    .overlay(
                        Image(systemName: "doc.viewfinder")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                    )
                
                VStack(spacing: 8) {
                    Text("Claims IQ Sidekick")
                        .font(Theme.title)
                        .foregroundColor(Theme.dark)
                    
                    Text("Version \(Constants.appVersion) (\(Constants.buildNumber))")
                        .font(Theme.callout)
                        .foregroundColor(Theme.dark.opacity(0.6))
                }
                
                Text("AI-powered field inspection and claims management for insurance adjusters.")
                    .font(Theme.callout)
                    .foregroundColor(Theme.dark.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
                
                Text("© 2025 Claims IQ. All rights reserved.")
                    .font(Theme.caption)
                    .foregroundColor(Theme.dark.opacity(0.5))
                    .padding(.bottom, 30)
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView()
}

