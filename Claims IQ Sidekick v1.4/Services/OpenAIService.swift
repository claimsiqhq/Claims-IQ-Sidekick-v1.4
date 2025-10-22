//
//  OpenAIService.swift
//  Claims IQ Sidekick v1.4
//
//  Created by John Shoust on 2025-10-22.
//

import Foundation
import UIKit

class OpenAIService {
    static let shared = OpenAIService()
    
    private var apiKey: String {
        UserDefaults.standard.string(forKey: Constants.openAIAPIKeyKey) ?? ""
    }
    
    private init() {}
    
    // MARK: - FNOL Processing
    
    func processFNOL(pdfData: Data) async throws -> FNOLExtractionResult {
        guard !apiKey.isEmpty else {
            throw OpenAIError.missingAPIKey
        }
        
        // Convert PDF to base64
        let base64PDF = pdfData.base64EncodedString()
        
        let prompt = """
        Analyze this First Notice of Loss (FNOL) document and extract all relevant information.
        
        Please extract and structure the following information:
        - Date and time of loss
        - Type of loss and cause
        - Property information (address, type, year built, square footage)
        - Damage assessment (affected areas, severity)
        - Insured information (name, contact details)
        - Policy information
        - Any immediate actions taken
        
        Return the information in a structured JSON format.
        """
        
        let response = try await callVisionAPI(
            prompt: prompt,
            base64Data: base64PDF,
            mimeType: "application/pdf"
        )
        
        return try parseFNOLResponse(response)
    }
    
    // MARK: - Workflow Generation
    
    func generateInspectionWorkflow(fnolData: FNOLExtractionResult) async throws -> WorkflowGenerationResult {
        guard !apiKey.isEmpty else {
            throw OpenAIError.missingAPIKey
        }
        
        let prompt = """
        Based on this FNOL data, generate a detailed inspection workflow for a field adjuster:
        
        Loss Type: \(fnolData.lossType ?? "Unknown")
        Cause: \(fnolData.cause ?? "Unknown")
        Affected Areas: \(fnolData.affectedAreas ?? "Unknown")
        Property Type: \(fnolData.propertyType ?? "Unknown")
        
        Create a step-by-step inspection workflow with the following structure:
        1. Each step should have a title and description
        2. Include specific checklist items for each step
        3. Tailor the workflow to the type of damage
        4. Include both interior and exterior inspection points
        5. End with documentation and review steps
        
        Return as a JSON array of steps, where each step has:
        - stepNumber
        - title
        - description
        - items (array of checklist item titles)
        """
        
        let response = try await callGPTAPI(prompt: prompt)
        return try parseWorkflowResponse(response)
    }
    
    // MARK: - Photo Annotation
    
    func annotatePhoto(imageData: Data) async throws -> PhotoAnnotationResult {
        guard !apiKey.isEmpty else {
            throw OpenAIError.missingAPIKey
        }
        
        let base64Image = imageData.base64EncodedString()
        
        let prompt = """
        Analyze this inspection photo and provide detailed annotations.
        
        Identify:
        - Type of damage visible
        - Severity assessment
        - Specific details about the damage
        - Areas of concern
        - Approximate measurements if possible
        - Any safety hazards
        
        Return annotations as a JSON array of strings, each being a concise observation.
        """
        
        let response = try await callVisionAPI(
            prompt: prompt,
            base64Data: base64Image,
            mimeType: "image/jpeg"
        )
        
        return try parsePhotoAnnotationResponse(response)
    }
    
    // MARK: - Daily Insights
    
    func generateDailyInsights(claims: [ClaimSummary], weather: String?, location: String?) async throws -> DailyInsightsResult {
        guard !apiKey.isEmpty else {
            throw OpenAIError.missingAPIKey
        }
        
        let claimsDescription = claims.map {
            "\($0.claimNumber): \($0.address) - \($0.status)"
        }.joined(separator: "\n")
        
        var contextParts = ["Active Claims:\n\(claimsDescription)"]
        if let weather = weather {
            contextParts.append("Weather: \(weather)")
        }
        if let location = location {
            contextParts.append("Location: \(location)")
        }
        
        let prompt = """
        As an AI assistant for insurance adjusters, analyze today's workload and provide insights:
        
        \(contextParts.joined(separator: "\n\n"))
        
        Generate:
        1. 3-5 actionable insights for today
        2. Prioritized list of tasks
        3. Routing suggestions based on locations
        4. Weather-related considerations
        
        Return as JSON with:
        - insights: array of insight strings
        - priorities: array of priority items
        - suggestions: array of suggestion strings
        """
        
        let response = try await callGPTAPI(prompt: prompt)
        return try parseDailyInsightsResponse(response)
    }
    
    // MARK: - API Calls
    
    private func callVisionAPI(prompt: String, base64Data: String, mimeType: String) async throws -> String {
        let url = URL(string: "\(Constants.openAIBaseURL)/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": Constants.visionModel,
            "messages": [
                [
                    "role": "user",
                    "content": [
                        ["type": "text", "text": prompt],
                        [
                            "type": "image_url",
                            "image_url": [
                                "url": "data:\(mimeType);base64,\(base64Data)"
                            ]
                        ]
                    ]
                ]
            ],
            "max_tokens": Constants.maxTokens
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw OpenAIError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw OpenAIError.apiError(statusCode: httpResponse.statusCode)
        }
        
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard let choices = json?["choices"] as? [[String: Any]],
              let message = choices.first?["message"] as? [String: Any],
              let content = message["content"] as? String else {
            throw OpenAIError.invalidResponse
        }
        
        return content
    }
    
    private func callGPTAPI(prompt: String) async throws -> String {
        let url = URL(string: "\(Constants.openAIBaseURL)/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": Constants.gptModel,
            "messages": [
                ["role": "system", "content": "You are an expert insurance claims assistant helping field adjusters with their daily tasks."],
                ["role": "user", "content": prompt]
            ],
            "max_tokens": Constants.maxTokens,
            "temperature": 0.7
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw OpenAIError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw OpenAIError.apiError(statusCode: httpResponse.statusCode)
        }
        
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard let choices = json?["choices"] as? [[String: Any]],
              let message = choices.first?["message"] as? [String: Any],
              let content = message["content"] as? String else {
            throw OpenAIError.invalidResponse
        }
        
        return content
    }
    
    // MARK: - Response Parsing
    
    private func parseFNOLResponse(_ response: String) throws -> FNOLExtractionResult {
        // Parse JSON response and extract structured data
        // For now, return a sample result
        return FNOLExtractionResult(
            dateOfLoss: Date(),
            timeOfLoss: "2:30 PM",
            lossType: "Water Damage",
            cause: "Burst Pipe",
            propertyType: "Single Family Home",
            yearBuilt: "1998",
            squareFootage: "2,400",
            affectedAreas: "Kitchen, Living Room",
            severity: "Moderate",
            extractedText: response
        )
    }
    
    private func parseWorkflowResponse(_ response: String) throws -> WorkflowGenerationResult {
        // Parse JSON response
        return WorkflowGenerationResult(
            rawResponse: response,
            steps: [] // Will be populated from JSON
        )
    }
    
    private func parsePhotoAnnotationResponse(_ response: String) throws -> PhotoAnnotationResult {
        // Parse JSON response
        return PhotoAnnotationResult(
            annotations: ["Sample annotation from AI"],
            rawResponse: response
        )
    }
    
    private func parseDailyInsightsResponse(_ response: String) throws -> DailyInsightsResult {
        // Parse JSON response
        return DailyInsightsResult(
            insights: [],
            priorities: [],
            suggestions: [],
            rawResponse: response
        )
    }
}

// MARK: - Models

struct FNOLExtractionResult {
    let dateOfLoss: Date?
    let timeOfLoss: String?
    let lossType: String?
    let cause: String?
    let propertyType: String?
    let yearBuilt: String?
    let squareFootage: String?
    let affectedAreas: String?
    let severity: String?
    let extractedText: String
}

struct WorkflowGenerationResult {
    let rawResponse: String
    let steps: [WorkflowStepData]
}

struct WorkflowStepData {
    let stepNumber: Int
    let title: String
    let description: String
    let items: [String]
}

struct PhotoAnnotationResult {
    let annotations: [String]
    let rawResponse: String
}

struct DailyInsightsResult {
    let insights: [String]
    let priorities: [String]
    let suggestions: [String]
    let rawResponse: String
}

struct ClaimSummary {
    let claimNumber: String
    let address: String
    let status: String
}

// MARK: - Errors

enum OpenAIError: LocalizedError {
    case missingAPIKey
    case invalidResponse
    case apiError(statusCode: Int)
    case parsingError
    
    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "OpenAI API key is not configured. Please add your API key in Settings."
        case .invalidResponse:
            return "Invalid response from OpenAI API"
        case .apiError(let statusCode):
            return "OpenAI API error: HTTP \(statusCode)"
        case .parsingError:
            return "Failed to parse OpenAI response"
        }
    }
}

