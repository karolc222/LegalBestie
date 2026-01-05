//  Report.swift
//  LegalBestie
//
//  Created by Carolina LC on 08/10/2025.

import Foundation
import SwiftData

@Model final class Report {
    @Attribute(.unique) var reportId: String
    var reportTitle: String
    var reportDescription: String
    var contentSummary: String
    var storagePath: String
    var createdAt: Date
    var updatedAt: Date
    
    var user: User?
    var legalArticles: [LegalArticle] = []
    
    init(
         reportId: String,
         reportTitle: String,
         reportDescription: String,
         contentSummary: String,
         storagePath: String,
         createdAt: Date,
         updatedAt: Date,
         user: User? = nil,
         legalArticles: [LegalArticle] = []
    ){
        
        self.reportId = reportId
        self.reportTitle = reportTitle
        self.contentSummary = contentSummary
        self.storagePath = storagePath
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.user = user
        self.legalArticles = legalArticles
        self.reportDescription = reportDescription
    }
}


extension Report {
    func generateFromScenario(scenario: Scenario) -> String {
        return "Report for Scenario: \(scenario.scenarioTitle)"
    }
    
}
