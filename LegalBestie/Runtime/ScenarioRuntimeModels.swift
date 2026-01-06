//  ScenarioRuntimeModels.swift
//  LegalBestie
//
//  Created by Carolina LC on 06/01/2026.

import Foundation

struct ScenarioTemplate: Decodable {
    let scenarioId: String
    let scenarioTitle: String
    let scenarioDescription: String
    let legalSummaryText: String
    let scenarioTopics: [String]
    let scenarioUpdatedAt: Date?
    let legalSources: [ScenarioSourceDTO]?
    let startNode: String
    let nodes: [String: ScenarioNode]
}

struct ScenarioNode: Decodable {
    let question: String
    let choices: [ScenarioChoice]
}

struct ScenarioChoice: Decodable, Hashable {
    let label: String
    let nextNode: String
}

struct ScenarioSourceDTO: Decodable, Identifiable {
    var id = UUID()
    let sourceTitle: String
    let sourceLink: URL
}
