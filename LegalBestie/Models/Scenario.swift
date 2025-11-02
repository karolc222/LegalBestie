import Foundation

struct Scenario: Codable {
    let scenarioId: String
    let scenarioTitle: String 
    let categoryId: String // FK to LegalCategory
    let scenarioDescription: String?
    let scenarioStartNode: String
    let scenarioNodes: [String: ScenarioNode]
    let legalSummaryText: String
    let legalSources: [LegalSource] // matches ScenarioSource link
    let updatedAt: Date?
}

struct ScenarioNode: Codable {
    let stepId: String
    let question: String?
    let choiceOptions: [Choice]?
    let type: String? // "question", "outcome", etc.
    let stepOutcome: String?
    let nextStepID: String?
    let isRequired: Bool
    let updated_at: Date
}

struct Choice: Codable {
    let label: String
    let nextNode: String
}

