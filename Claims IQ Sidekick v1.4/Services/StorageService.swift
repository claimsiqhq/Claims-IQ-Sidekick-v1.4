//
//  StorageService.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import Foundation
import UIKit

class StorageService {
    static let shared = StorageService()
    
    private init() {
        setupDirectories()
    }
    
    private func setupDirectories() {
        let directories = [
            Constants.photosDirectory,
            Constants.fnolDirectory,
            Constants.lidarDirectory
        ]
        
        for directory in directories {
            if !FileManager.default.fileExists(atPath: directory.path) {
                try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            }
        }
    }
    
    // MARK: - Photo Storage
    
    func savePhoto(_ image: UIImage, for claimNumber: String) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            return nil
        }
        
        let filename = "\(claimNumber)_\(UUID().uuidString).jpg"
        let fileURL = Constants.photosDirectory.appendingPathComponent(filename)
        
        do {
            try data.write(to: fileURL)
            return fileURL.path
        } catch {
            print("Error saving photo: \(error)")
            return nil
        }
    }
    
    func loadPhoto(from path: String) -> UIImage? {
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        return UIImage(data: data)
    }
    
    func deletePhoto(at path: String) {
        let url = URL(fileURLWithPath: path)
        try? FileManager.default.removeItem(at: url)
    }
    
    // MARK: - FNOL Storage
    
    func saveFNOL(_ data: Data, filename: String) -> String? {
        let fileURL = Constants.fnolDirectory.appendingPathComponent(filename)
        
        do {
            try data.write(to: fileURL)
            return fileURL.path
        } catch {
            print("Error saving FNOL: \(error)")
            return nil
        }
    }
    
    func loadFNOL(from path: String) -> Data? {
        let url = URL(fileURLWithPath: path)
        return try? Data(contentsOf: url)
    }
    
    func deleteFNOL(at path: String) {
        let url = URL(fileURLWithPath: path)
        try? FileManager.default.removeItem(at: url)
    }
    
    // MARK: - LiDAR Storage
    
    func saveLiDARScan(_ data: Data, for claimNumber: String) -> String? {
        let filename = "\(claimNumber)_\(UUID().uuidString).lidar"
        let fileURL = Constants.lidarDirectory.appendingPathComponent(filename)
        
        do {
            try data.write(to: fileURL)
            return fileURL.path
        } catch {
            print("Error saving LiDAR scan: \(error)")
            return nil
        }
    }
    
    func loadLiDARScan(from path: String) -> Data? {
        let url = URL(fileURLWithPath: path)
        return try? Data(contentsOf: url)
    }
    
    func deleteLiDARScan(at path: String) {
        let url = URL(fileURLWithPath: path)
        try? FileManager.default.removeItem(at: url)
    }
    
    // MARK: - Storage Management
    
    func getStorageUsage() -> StorageUsage {
        var usage = StorageUsage()
        
        usage.photos = getDirectorySize(Constants.photosDirectory)
        usage.fnols = getDirectorySize(Constants.fnolDirectory)
        usage.lidarScans = getDirectorySize(Constants.lidarDirectory)
        
        return usage
    }
    
    private func getDirectorySize(_ directory: URL) -> Int64 {
        var size: Int64 = 0
        
        if let enumerator = FileManager.default.enumerator(at: directory, includingPropertiesForKeys: [.fileSizeKey]) {
            for case let fileURL as URL in enumerator {
                if let fileSize = try? fileURL.resourceValues(forKeys: [.fileSizeKey]).fileSize {
                    size += Int64(fileSize)
                }
            }
        }
        
        return size
    }
    
    func clearCache() {
        // Clear temporary files and cached data
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        if let cacheDir = cacheDirectory {
            try? FileManager.default.removeItem(at: cacheDir)
            try? FileManager.default.createDirectory(at: cacheDir, withIntermediateDirectories: true)
        }
    }
}

struct StorageUsage {
    var photos: Int64 = 0
    var fnols: Int64 = 0
    var lidarScans: Int64 = 0
    var cache: Int64 = 0
    
    var total: Int64 {
        photos + fnols + lidarScans + cache
    }
    
    func formattedSize(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
}


