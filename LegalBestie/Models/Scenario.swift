import Foundation
import SwiftData

@Model
final class Scenario {
    var scenarioId: String
    var scenarioTitle: String
    var categoryIds: [String] // FK to LegalCategory
    var scenarioDescription: String?
    var scenarioStartNode: String
    var legalSummaryText: String
    var legalSources: [LegalSourceDTO] // matches ScenarioSource link
    var updatedAt: Date?
    
    //not to be saved in the db
    @Transient var currentNodeKey: String?
    
    init(
        scenarioId: String,
        scenarioTitle: String,
        categoryId: String,
        scenarioDescription: String? = nil,
        scenarioStartNode: String,
        legalSummaryText: String,
        legalSources: [LegalSourceDTO],
        updatedAt: Date? = nil
    ){
        self.scenarioId = scenarioId
        self.scenarioTitle = scenarioTitle
        self.categoryIds = [categoryId]
        self.scenarioDescription = scenarioDescription
        self.scenarioStartNode = scenarioStartNode
        self.legalSummaryText = legalSummaryText
        self.legalSources = legalSources
        self.updatedAt = updatedAt
    }
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
