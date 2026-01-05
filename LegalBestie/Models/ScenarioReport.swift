//  ScenarioReport.swift
//  LegalBestie
//
//  Created by Carolina LC on 18/11/2025.

import Foundation
import SwiftData

// report based on user's answers and contains the legal summary

@Model
final class ScenarioReport {
    @Attribute(.unique) var id: String
    var userId: String
    var scenarioId: String
    var scenarioTitle: String
    var createdAt: Date?
    var updatedAt: Date?
    
    //user transcript of answers
    var steps: [StepReport]
    
    var legalSummary: String
    var legalSources: [LegalSource]
    

    
    init(
        id: String = UUID().uuidString,
        userId: String,
        scenarioId: String,
        scenarioTitle: String,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        
        steps: [StepReport],
        legalSummary: String,
        legalSources: [LegalSource]
    ) {
        
        self.id = id
        self.userId = userId
        self.scenarioId = scenarioId
        self.scenarioTitle = scenarioTitle
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.steps = steps
        self.legalSummary = legalSummary
        self.legalSources = legalSources
    }
}
