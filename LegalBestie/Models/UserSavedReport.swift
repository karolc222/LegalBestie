//  UserSavedReport.swift
//  LegalBuddy
//
//  Created by Carolina LC on 08/10/2025.

import Foundation
import SwiftData

@Model
final class UserSavedReport {

    @Attribute(.unique) var id: String
    var userId: String
    var reportTitle: String
    var sourcesText: String?
    var savedAt: Date

    init(
        id: String = UUID().uuidString,
        userId: String,
        reportTitle: String,
        sourcesText: String? = nil,
        savedAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.reportTitle = reportTitle
        self.sourcesText = sourcesText
        self.savedAt = savedAt
    }
    
    var formattedDate : String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: savedAt)
    }
}


