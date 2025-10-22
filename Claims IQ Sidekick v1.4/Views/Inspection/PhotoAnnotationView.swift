//
//  PhotoAnnotationView.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import SwiftUI

struct PhotoAnnotationView: View {
    let photo: UIImage
    @State private var annotations: [PhotoAnnotation] = []
    @State private var newAnnotationText = ""
    @State private var isAddingAnnotation = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Photo with annotation overlay
                ZStack {
                    Image(uiImage: photo)
                        .resizable()
                        .scaledToFit()
                    
                    // Annotation markers
                    ForEach(annotations) { annotation in
                        AnnotationMarker(annotation: annotation)
                    }
                }
                .frame(maxHeight: .infinity)
                .background(Color.black)
                
                // Annotations list
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Annotations")
                            .font(Theme.headline)
                            .foregroundColor(Theme.dark)
                        
                        Spacer()
                        
                        Button(action: { isAddingAnnotation = true }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(Theme.primary)
                                .font(.title3)
                        }
                    }
                    
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(annotations) { annotation in
                                AnnotationRow(annotation: annotation)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .frame(height: 250)
            }
            .navigationTitle("Annotate Photo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Save annotations
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .sheet(isPresented: $isAddingAnnotation) {
                AddAnnotationSheet(
                    text: $newAnnotationText,
                    onSave: {
                        addAnnotation()
                    }
                )
            }
        }
    }
    
    private func addAnnotation() {
        let newAnnotation = PhotoAnnotation(
            text: newAnnotationText,
            position: CGPoint(x: 0.5, y: 0.5),
            timestamp: Date()
        )
        annotations.append(newAnnotation)
        newAnnotationText = ""
        isAddingAnnotation = false
    }
}

struct PhotoAnnotation: Identifiable {
    let id = UUID()
    let text: String
    let position: CGPoint
    let timestamp: Date
}

struct AnnotationMarker: View {
    let annotation: PhotoAnnotation
    
    var body: some View {
        Circle()
            .fill(Theme.accentPrimary)
            .frame(width: 30, height: 30)
            .overlay(
                Text("!")
                    .font(.headline.weight(.bold))
                    .foregroundColor(.white)
            )
    }
}

struct AnnotationRow: View {
    let annotation: PhotoAnnotation
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "tag.fill")
                .foregroundColor(Theme.accentPrimary)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(annotation.text)
                    .font(Theme.callout)
                    .foregroundColor(Theme.dark)
                
                Text(annotation.timestamp.formatted(date: .omitted, time: .shortened))
                    .font(Theme.caption)
                    .foregroundColor(Theme.dark.opacity(0.6))
            }
            
            Spacer()
        }
        .padding()
        .background(Theme.neutral1)
        .cornerRadius(Theme.cornerRadiusMedium)
    }
}

struct AddAnnotationSheet: View {
    @Binding var text: String
    let onSave: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextEditor(text: $text)
                    .frame(height: 150)
                    .padding()
                    .background(Theme.neutral1)
                    .cornerRadius(Theme.cornerRadiusMedium)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Add Annotation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        onSave()
                        dismiss()
                    }
                    .disabled(text.isEmpty)
                }
            }
        }
    }
}

#Preview {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 400, height: 600))
    let image = renderer.image { ctx in
        UIColor.gray.setFill()
        ctx.fill(CGRect(x: 0, y: 0, width: 400, height: 600))
    }
    
    return PhotoAnnotationView(photo: image)
}


