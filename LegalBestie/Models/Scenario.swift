//  Scenario.swift
//  LegalBestie
//
//  Created by Carolina LC on 18/11/2025.

import Foundation
import SwiftData

//not used for JSON decoding
// represents original legal scenario from JSON files

@Model
final class Scenario {
    @Attribute(.unique) var scenarioId: String
    var scenarioTitle: String
    var categoryIds: [String] // FK to LegalCategory
    var scenarioDescription: String?
    var scenarioStartNode: String
    var legalSummaryText: String
    var legalSources: [LegalSource]
    var scenarioUpdatedAt: Date?
    
    @Transient var currentNodeKey: String?
    
    init(
        scenarioId: String,
        scenarioTitle: String,
        categoryId: String,
        scenarioDescription: String? = nil,
        scenarioStartNode: String,
        legalSummaryText: String,
        legalSources: [LegalSource],
        updatedAt: Date? = nil
    ){
        self.scenarioId = scenarioId
        self.scenarioTitle = scenarioTitle
        self.categoryIds = [categoryId]
        self.scenarioDescription = scenarioDescription
        self.scenarioStartNode = scenarioStartNode
        self.legalSummaryText = legalSummaryText
        self.legalSources = legalSources
        self.scenarioUpdatedAt = updatedAt
    }
}

struct ScenarioNode: Codable {
    let stepId: String
    let question: String
    let choices: [Choice]
    let type: String? // "question" or "outcome"
    let stepOutcome: String?
    let nextStepID: String?
    let isRequired: Bool
    let updatedAt: Date?
}

struct Choice: Codable, Hashable {
    let label: String
    let nextNode: String
}

// legal source reference in the scenario
struct ChoiceDTO: Codable, Hashable, Identifiable {
    let sourceId: String
        let sourceTitle: String
        let sourceLink: URL
        let sourceDescription: String
        let sourceOrganization: String
        let sourceStatus: String
        let scenarioTopics: [String]
        
        var id: String { sourceId }
}

// runtime Codable structs to decode JSON into memory
struct ScenarioTemplate: Codable {
    let scenarioId: String
    let scenarioTitle: String
    let categoryName: String
    let scenarioDescription: String
    let startNode: String
    let nodes: [String: ScenarioNode]
    let legalSummaryText: String
    let legalSources: [ScenarioSourceDTO]?
    let scenarioUpdatedAt: Date?
    let scenarioTopics: [String]
}

struct ScenarioSourceDTO: Codable, Hashable, Identifiable {
    let sourceId: String
    let sourceTitle: String
    let sourceLink: URL
    let sourceDescription: String
    let sourceOrganization: String
    let sourceStatus: String
    let scenarioTopics: [String]
    
    var id: String { sourceId }
}

struct ScenarioListItem: Identifiable {
    let id = UUID()
    let fileName: String
    let title: String
    let description: String
    let updatedAt: Date
}


