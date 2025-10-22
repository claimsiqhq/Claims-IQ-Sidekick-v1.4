//
//  PhotoCaptureView.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import SwiftUI
import AVFoundation

struct PhotoCaptureView: View {
    let claim: Claim
    @Environment(\.dismiss) private var dismiss
    @State private var capturedImage: UIImage?
    @State private var isProcessing = false
    @State private var annotations: [String] = []
    @State private var showCamera = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                if showCamera && capturedImage == nil {
                    CameraPreviewView(capturedImage: $capturedImage)
                        .ignoresSafeArea()
                    
                    VStack {
                        Spacer()
                        
                        cameraControls
                    }
                } else if let image = capturedImage {
                    if isProcessing {
                        processingView
                    } else {
                        photoReviewView(image: image)
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
    
    private var cameraControls: some View {
        VStack(spacing: 20) {
            // Info bar
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "location.fill")
                        .foregroundColor(Theme.accentPrimary)
                    Text("GPS: Active")
                        .font(Theme.caption)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.6))
                .cornerRadius(20)
                
                Spacer()
                
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .foregroundColor(Theme.accentPrimary)
                    Text("AI Annotation: Ready")
                        .font(Theme.caption)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.6))
                .cornerRadius(20)
            }
            .padding(.horizontal)
            
            // Capture button
            HStack(spacing: 40) {
                Button(action: {}) {
                    Image(systemName: "photo.on.rectangle")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                }
                
                Button(action: capturePhoto) {
                    Circle()
                        .strokeBorder(Color.white, lineWidth: 4)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Circle()
                                .fill(Color.white)
                                .frame(width: 68, height: 68)
                        )
                }
                
                Button(action: {}) {
                    Image(systemName: "camera.rotate")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                }
            }
            .padding(.bottom, 40)
        }
    }
    
    private var processingView: some View {
        VStack(spacing: 30) {
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundColor(Theme.accentPrimary)
                .symbolEffect(.pulse)
            
            VStack(spacing: 12) {
                Text("AI is analyzing...")
                    .font(Theme.headline)
                    .foregroundColor(Theme.dark)
                
                Text("Detecting damage and generating annotations")
                    .font(Theme.callout)
                    .foregroundColor(Theme.dark.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
            
            ProgressView()
                .tint(Theme.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
    
    private func photoReviewView(image: UIImage) -> some View {
        VStack(spacing: 0) {
            // Image preview
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: .infinity)
            
            // Annotations section
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "sparkles")
                        .foregroundColor(Theme.accentPrimary)
                    Text("AI Annotations")
                        .font(Theme.headline)
                        .foregroundColor(Theme.dark)
                    
                    Spacer()
                    
                    Button("Edit") {}
                        .font(Theme.callout)
                        .foregroundColor(Theme.primary)
                }
                
                if annotations.isEmpty {
                    Text("No annotations detected")
                        .font(Theme.callout)
                        .foregroundColor(Theme.dark.opacity(0.6))
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(annotations, id: \.self) { annotation in
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Theme.primary)
                                    .font(.caption)
                                Text(annotation)
                                    .font(Theme.callout)
                                    .foregroundColor(Theme.dark)
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color.white)
            
            // Action buttons
            HStack(spacing: 12) {
                Button("Retake") {
                    capturedImage = nil
                    annotations = []
                    showCamera = true
                }
                .font(Theme.callout.weight(.semibold))
                .foregroundColor(Theme.dark)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Theme.neutral2)
                .cornerRadius(Theme.cornerRadiusMedium)
                
                Button("Save Photo") {
                    savePhoto()
                }
                .font(Theme.callout.weight(.semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Theme.primaryGradient)
                .cornerRadius(Theme.cornerRadiusMedium)
            }
            .padding()
            .background(Color.white)
        }
    }
    
    private func capturePhoto() {
        // Simulate photo capture
        showCamera = false
        
        // Create a placeholder image
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 400, height: 600))
        let image = renderer.image { ctx in
            Theme.neutral2.setFill()
            ctx.fill(CGRect(x: 0, y: 0, width: 400, height: 600))
        }
        
        capturedImage = image
        processWithAI()
    }
    
    private func processWithAI() {
        isProcessing = true
        
        // Simulate AI processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            annotations = [
                "Water damage visible on ceiling",
                "Discoloration pattern suggests active leak",
                "Affected area approximately 3ft x 4ft"
            ]
            isProcessing = false
        }
    }
    
    private func savePhoto() {
        // Save photo with annotations
        dismiss()
    }
}

// Camera preview wrapper
struct CameraPreviewView: UIViewRepresentable {
    @Binding var capturedImage: UIImage?
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        
        // Add placeholder camera icon
        let imageView = UIImageView(image: UIImage(systemName: "camera.fill"))
        imageView.tintColor = .white.withAlphaComponent(0.3)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

#Preview {
    PhotoCaptureView(claim: Claim(
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


