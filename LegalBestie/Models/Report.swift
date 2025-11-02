//  Report.swift
//  LegalBuddy
//
//  Created by Carolina LC on 08/10/2025.

import Foundation

struct Report: Codable {
    let reportID: String
    let reportType: String
    let reportTitle: String
    let reportStatus: String
    let reportDescription: String
    let contentSummary: String
    let storagePath: String
    let createdAt: Date
    let updatedAt: Date
    
    //let user: User
    //let legalArticles: [LegalArticle]
    
    // Generates a report summary based on user data and scenario.
    func generateFromScenario(scenario: Scenario) -> String {
        return "Report for Scenario: \(scenario.scenarioTitle)"
    }
    
    // Adds relevant articles or saved items to the report content.
    func collectData(from items: [UserSavedItem]) -> [String] {
        var collectedInfo: [String] = []
        for item in items {
            switch item.itemType {
            case "article":
                collectedInfo.append("Article: \(item.itemTitle) — \(item.itemContent)")
            case "note":
                collectedInfo.append("Note: \(item.itemContent)")
            case "query":
                collectedInfo.append("Chat Query: \(item.itemContent)")
            default:
                collectedInfo.append("Other: \(item.itemContent)")
            }
        }
        return collectedInfo
    }
}
