//  UserSavedReport.swift
//  LegalBestie
//
//  Created by Carolina LC on 08/10/2025.

import Foundation
import SwiftData

@Model
final class UserSavedReport {
    @Attribute(.unique) var id: String
    var userid: String
    var reportTitle: String
    var scenarioCategory: String
    var outcome: String
    var sources: [String]  // Array of source titles
    var savedAt: Date

    init(
        id: String = UUID().uuidString,
        userid: String,
        reportTitle: String,
        scenarioCategory: String,
        outcome: String,
        sources: [String] = [],
        savedAt: Date = Date()
    ) {
        self.id = id
        self.userid = userid
        self.reportTitle = reportTitle
        self.scenarioCategory = scenarioCategory
        self.outcome = outcome
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
