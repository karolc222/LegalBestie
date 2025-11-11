//  Report.swift
//  LegalBestie
//
//  Created by Carolina LC on 08/10/2025.

import Foundation
import SwiftData

@Model final class Report{
    @Attribute(.unique) var reportId: String
    var reportType: String
    var reportTitle: String
    var reportStatus: String
    var reportDescription: String
    var contentSummary: String
    var storagePath: String
    var createdAt: Date
    var updatedAt: Date
    
    var user: User?
    var legalArticles: [LegalArticle] = []
    
    init(
         reportId: String,
         reportType: String,
         reportTitle: String,
         reportStatus: String,
         reportDescription: String,
         contentSummary: String,
         storagePath: String,
         createdAt: Date,
         updatedAt: Date,
         user: User? = nil,
         legalArticles: [LegalArticle] = []
    ){
        
        self.reportId = reportId
        self.reportType = reportType
        self.reportTitle = reportTitle
        self.reportStatus = reportStatus
        self.reportDescription = reportDescription
        self.contentSummary = contentSummary
        self.storagePath = storagePath
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.user = user
        self.legalArticles = legalArticles
    }
}


// Generates a report summary based on user data and scenario.
extension Report {
    func generateFromScenario(scenario: Scenario) -> String {
        return "Report for Scenario: \(scenario.scenarioTitle)"
    }
    
    /// Adds relevant articles or saved items to the report content.
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
