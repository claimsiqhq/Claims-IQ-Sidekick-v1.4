//
//  FNOLUploadView.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import SwiftUI
import UniformTypeIdentifiers

struct FNOLUploadView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isProcessing = false
    @State private var showDocumentPicker = false
    @State private var selectedDocument: URL?
    @State private var processingProgress: Double = 0.0
    @State private var extractedData: String?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: Theme.paddingLarge) {
                if isProcessing {
                    processingView
                } else if extractedData != nil {
                    successView
                } else {
                    uploadView
                }
            }
            .padding()
            .navigationTitle("Upload FNOL")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showDocumentPicker) {
                DocumentPicker(selectedDocument: $selectedDocument)
            }
            .onChange(of: selectedDocument) { _, newValue in
                if newValue != nil {
                    processDocument()
                }
            }
        }
    }
    
    private var uploadView: some View {
        VStack(spacing: Theme.paddingXLarge) {
            Spacer()
            
            Image(systemName: "doc.text.fill")
                .font(.system(size: 80))
                .foregroundColor(Theme.primary)
            
            VStack(spacing: 12) {
                Text("Upload FNOL Document")
                    .font(Theme.title)
                    .foregroundColor(Theme.dark)
                
                Text("Select a PDF file containing the First Notice of Loss. AI will automatically extract and analyze the contents.")
                    .font(Theme.callout)
                    .foregroundColor(Theme.dark.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Button(action: { showDocumentPicker = true }) {
                HStack {
                    Image(systemName: "doc.badge.plus")
                    Text("Select PDF")
                        .font(Theme.headline)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Theme.primaryGradient)
                .cornerRadius(Theme.cornerRadiusMedium)
            }
            .padding(.horizontal, Theme.paddingXLarge)
            
            Spacer()
            
            // Info cards
            VStack(spacing: 12) {
                InfoCard(
                    icon: "eye.fill",
                    title: "AI Vision Analysis",
                    description: "Uses OpenAI Vision to read and extract data"
                )
                
                InfoCard(
                    icon: "bolt.fill",
                    title: "Instant Processing",
                    description: "Get structured data in seconds"
                )
                
                InfoCard(
                    icon: "checkmark.shield.fill",
                    title: "Secure & Private",
                    description: "Your documents are processed securely"
                )
            }
        }
    }
    
    private var processingView: some View {
        VStack(spacing: Theme.paddingXLarge) {
            Spacer()
            
            ProgressView(value: processingProgress)
                .progressViewStyle(.linear)
                .tint(Theme.primary)
                .scaleEffect(x: 1, y: 2, anchor: .center)
            
            VStack(spacing: 12) {
                Image(systemName: "sparkles")
                    .font(.system(size: 60))
                    .foregroundColor(Theme.accentPrimary)
                    .symbolEffect(.pulse)
                
                Text("Processing with AI...")
                    .font(Theme.headline)
                    .foregroundColor(Theme.dark)
                
                Text("Extracting and analyzing FNOL data")
                    .font(Theme.callout)
                    .foregroundColor(Theme.dark.opacity(0.6))
            }
            
            Spacer()
        }
    }
    
    private var successView: some View {
        VStack(spacing: Theme.paddingLarge) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            Text("FNOL Processed Successfully!")
                .font(Theme.title)
                .foregroundColor(Theme.dark)
            
            Text("The document has been analyzed and data extracted.")
                .font(Theme.callout)
                .foregroundColor(Theme.dark.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button(action: {
                dismiss()
            }) {
                Text("View Claim")
                    .font(Theme.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Theme.primaryGradient)
                    .cornerRadius(Theme.cornerRadiusMedium)
            }
        }
        .padding()
    }
    
    private func processDocument() {
        isProcessing = true
        processingProgress = 0.0
        
        // Simulate AI processing
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            processingProgress += 0.05
            if processingProgress >= 1.0 {
                timer.invalidate()
                // Simulate completion
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    extractedData = "Sample extracted data"
                    isProcessing = false
                }
            }
        }
    }
}

struct InfoCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(Theme.primary)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(Theme.callout.weight(.semibold))
                    .foregroundColor(Theme.dark)
                
                Text(description)
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

// Document Picker wrapper
struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var selectedDocument: URL?
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            parent.selectedDocument = url
        }
    }
}

#Preview {
    FNOLUploadView()
}


