import Foundation
import SwiftData

//not used for JSON decoding

@Model
final class Scenario {
    @Attribute(.unique) var scenarioId: String
    var scenarioTitle: String
    var categoryIds: [String] // FK to LegalCategory
    var scenarioDescription: String?
    var scenarioStartNode: String
    var legalSummaryText: String
    var legalSources: [LegalSource] // persisted sources
    var scenarioUpdatedAt: Date?
    
    //not to be saved in the db
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
    let type: String? // "question", "outcome", etc.
    let stepOutcome: String?
    let nextStepID: String?
    let isRequired: Bool
    let updatedAt: Date
}

struct Choice: Codable {
    let label: String
    let nextNode: String
}
