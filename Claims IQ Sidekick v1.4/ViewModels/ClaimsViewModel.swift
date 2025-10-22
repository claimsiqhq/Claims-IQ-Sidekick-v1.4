//
//  ClaimsViewModel.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
class ClaimsViewModel: ObservableObject {
    @Published var isProcessingFNOL = false
    @Published var processingError: Error?
    @Published var selectedClaim: Claim?
    
    private let openAIService = OpenAIService.shared
    private let storageService = StorageService.shared
    private let syncManager = SyncManager.shared
    
    func processFNOL(documentURL: URL, modelContext: ModelContext) async -> Claim? {
        isProcessingFNOL = true
        processingError = nil
        
        do {
            // Load PDF data
            let data = try Data(contentsOf: documentURL)
            
            // Save to local storage
            let filename = documentURL.lastPathComponent
            guard let savedPath = storageService.saveFNOL(data, filename: filename) else {
                throw NSError(domain: "Storage", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to save FNOL"])
            }
            
            // Process with OpenAI
            let result = try await openAIService.processFNOL(pdfData: data)
            
            // Create FNOL model
            let fnol = FNOL(documentPath: savedPath)
            fnol.extractedText = result.extractedText
            fnol.processingStatus = "completed"
            fnol.dateOfLoss = result.dateOfLoss
            fnol.timeOfLoss = result.timeOfLoss
            fnol.lossType = result.lossType
            fnol.cause = result.cause
            fnol.propertyType = result.propertyType
            fnol.yearBuilt = result.yearBuilt
            fnol.squareFootage = result.squareFootage
            fnol.affectedAreas = result.affectedAreas
            fnol.severity = result.severity
            
            // Create claim
            let claim = Claim(
                claimNumber: "CLM-\(Int.random(in: 100000...999999))",
                address: "Extracted from FNOL", // Will be updated with actual address
                claimType: result.lossType ?? "Unknown",
                policyNumber: "POL-\(Int.random(in: 100000...999999))",
                insuredName: "Extracted from FNOL",
                contactPhone: "",
                claimDescription: result.cause ?? "",
                status: "Active"
            )
            
            claim.fnol = fnol
            claim.hasFNOL = true
            fnol.claim = claim
            
            // Save to database
            modelContext.insert(claim)
            modelContext.insert(fnol)
            try modelContext.save()
            
            // Queue for sync if offline
            if !NetworkMonitor.shared.isConnected {
                syncManager.queueOperation(SyncOperation(
                    type: .uploadFNOL,
                    data: data,
                    timestamp: Date()
                ))
            }
            
            isProcessingFNOL = false
            return claim
            
        } catch {
            processingError = error
            isProcessingFNOL = false
            return nil
        }
    }
    
    func generateWorkflow(for claim: Claim, modelContext: ModelContext) async {
        guard let fnol = claim.fnol else { return }
        
        do {
            let fnolResult = FNOLExtractionResult(
                dateOfLoss: fnol.dateOfLoss,
                timeOfLoss: fnol.timeOfLoss,
                lossType: fnol.lossType,
                cause: fnol.cause,
                propertyType: fnol.propertyType,
                yearBuilt: fnol.yearBuilt,
                squareFootage: fnol.squareFootage,
                affectedAreas: fnol.affectedAreas,
                severity: fnol.severity,
                extractedText: fnol.extractedText
            )
            
            let result = try await openAIService.generateInspectionWorkflow(fnolData: fnolResult)
            
            // Create workflow
            let workflow = InspectionWorkflow(
                title: "Inspection for \(claim.claimNumber)",
                description: "AI-generated workflow",
                aiPrompt: "",
                aiResponse: result.rawResponse
            )
            
            // Add steps and items
            for (index, stepData) in result.steps.enumerated() {
                let step = InspectionStep(
                    stepNumber: index + 1,
                    title: stepData.title,
                    description: stepData.description
                )
                
                for itemTitle in stepData.items {
                    let item = InspectionItem(title: itemTitle)
                    step.items.append(item)
                    item.step = step
                }
                
                workflow.steps.append(step)
                step.workflow = workflow
            }
            
            claim.workflow = workflow
            claim.hasWorkflow = true
            workflow.claim = claim
            
            modelContext.insert(workflow)
            try modelContext.save()
            
        } catch {
            processingError = error
        }
    }
}


