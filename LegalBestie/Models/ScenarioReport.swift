//  ScenarioReport.swift
//  LegalBestie
//
//  Created by Carolina LC on 18/11/2025.

import Foundation
import SwiftData

@Model
final class ScenarioReport {
    @Attribute(.unique) var id: String
    var scenarioId: String
    var scenarioTitle: String
    var createdAt: Date?
    var updatedAt: Date?
    var status: String //draft/completed
    
    //user transcript of answers
    var steps: [StepReport]
    
    var legalSummary: String
    var legalSources: [LegalSource]
    
    //optional
    var userNotes: String?
    var evidence: [EvidenceItem]?
    
    init(
        id: String = UUID().uuidString,
        scenarioId: String,
        scenarioTitle: String,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        status: String,
        steps: [StepReport],
        legalSummary: String,
        legalSources: [LegalSource],
        userNotes: String? = nil,
        evidence: [EvidenceItem]? = nil
    ) {
        self.id = id
        self.scenarioId = scenarioId
        self.scenarioTitle = scenarioTitle
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.status = status
        self.steps = steps
        self.legalSummary = legalSummary
        self.legalSources = legalSources
        self.userNotes = userNotes
        self.evidence = evidence
    }
}
