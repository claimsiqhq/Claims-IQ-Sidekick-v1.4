//
//  LiDARCaptureView.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import SwiftUI
import RealityKit
import ARKit

struct LiDARCaptureView: View {
    let claim: Claim
    @Environment(\.dismiss) private var dismiss
    @State private var isScanning = false
    @State private var scanProgress: Double = 0.0
    @State private var scanComplete = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // AR View placeholder
                ARViewContainer(isScanning: $isScanning, scanProgress: $scanProgress)
                    .ignoresSafeArea()
                
                VStack {
                    // Top info bar
                    if isScanning {
                        scanningInfoBar
                    }
                    
                    Spacer()
                    
                    // Bottom controls
                    if !scanComplete {
                        scanControls
                    } else {
                        scanCompleteView
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
    
    private var scanningInfoBar: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "light.beacon.max.fill")
                    .foregroundColor(Theme.accentPrimary)
                Text("LiDAR Scanning Active")
                    .font(Theme.callout.weight(.semibold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.black.opacity(0.6))
            .cornerRadius(25)
            
            // Progress
            VStack(spacing: 8) {
                ProgressView(value: scanProgress)
                    .progressViewStyle(.linear)
                    .tint(Theme.accentPrimary)
                    .frame(width: 200)
                
                Text("\(Int(scanProgress * 100))% Complete")
                    .font(Theme.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(12)
            }
        }
        .padding()
    }
    
    private var scanControls: some View {
        VStack(spacing: 20) {
            // Instructions
            if !isScanning {
                VStack(spacing: 12) {
                    Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                        .font(.title)
                        .foregroundColor(Theme.accentPrimary)
                    
                    Text("Move your device slowly to scan the area")
                        .font(Theme.callout)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                .padding(20)
                .background(Color.black.opacity(0.6))
                .cornerRadius(Theme.cornerRadiusLarge)
                .padding(.horizontal)
            }
            
            // Scan button
            Button(action: toggleScanning) {
                HStack(spacing: 12) {
                    Image(systemName: isScanning ? "stop.fill" : "light.beacon.max")
                        .font(.title2)
                    Text(isScanning ? "Stop Scanning" : "Start LiDAR Scan")
                        .font(Theme.headline)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(isScanning ? Color.red : Theme.accentGradient)
                .cornerRadius(Theme.cornerRadiusMedium)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
    
    private var scanCompleteView: some View {
        VStack(spacing: 20) {
            VStack(spacing: 16) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                
                Text("Scan Complete!")
                    .font(Theme.title)
                    .foregroundColor(.white)
                
                Text("3D model captured successfully")
                    .font(Theme.callout)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(30)
            .background(Color.black.opacity(0.7))
            .cornerRadius(Theme.cornerRadiusLarge)
            
            HStack(spacing: 12) {
                Button("Scan Again") {
                    scanComplete = false
                    scanProgress = 0
                }
                .font(Theme.callout.weight(.semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.white.opacity(0.2))
                .cornerRadius(Theme.cornerRadiusMedium)
                
                Button("Save Scan") {
                    saveScan()
                }
                .font(Theme.callout.weight(.semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Theme.accentGradient)
                .cornerRadius(Theme.cornerRadiusMedium)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
    
    private func toggleScanning() {
        isScanning.toggle()
        
        if isScanning {
            // Simulate scanning progress
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                scanProgress += 0.02
                if scanProgress >= 1.0 {
                    timer.invalidate()
                    isScanning = false
                    scanComplete = true
                }
            }
        }
    }
    
    private func saveScan() {
        // Save the LiDAR scan
        dismiss()
    }
}

// ARView Container
struct ARViewContainer: UIViewRepresentable {
    @Binding var isScanning: Bool
    @Binding var scanProgress: Double
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        
        // Placeholder for AR view
        let label = UILabel()
        label.text = "LiDAR AR View\n(Requires ARKit)"
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Add grid pattern
        let imageView = UIImageView(image: UIImage(systemName: "grid"))
        imageView.tintColor = .white.withAlphaComponent(0.2)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

#Preview {
    LiDARCaptureView(claim: Claim(
        claimNumber: "CLM-001234",
        address: "123 Main St",
        claimType: "Property",
        policyNumber: "POL-123",
        insuredName: "John Doe",
        contactPhone: "555-1234",
        claimDescription: "Test",
        status: "Active"
    ))
}


