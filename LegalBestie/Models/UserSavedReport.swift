//  UserSavedReport.swift
//  LegalBestie
//
//  Created by Carolina LC on 08/10/2025.

import Foundation
import SwiftData

@Model
final class UserSavedReport {
    @Attribute(.unique) var id: String
    var userId: String
    var reportTitle: String
    var scenarioCategory: String
    var outcome: String
    var legalSummary: String?
    var incidentSteps: [String]
    var sources: [String]  
    var savedAt: Date

    init(
        id: String = UUID().uuidString,
        userId: String,
        reportTitle: String,
        scenarioCategory: String,
        outcome: String,
        legalSummary: String?,
        incidentSteps: [String],
        sources: [String] = [],
        savedAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.reportTitle = reportTitle
        self.scenarioCategory = scenarioCategory
        self.outcome = outcome
        self.legalSummary = legalSummary
        self.incidentSteps = incidentSteps
        self.sources = sources
        self.savedAt = savedAt
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: savedAt)
    }
}
