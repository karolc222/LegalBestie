//  User.swift
//  LegalBestie
//
//  Created by Carolina LC on 08/10/2025.

import Foundation
import SwiftData

@Model final class User {
    @Attribute(.unique) var userId: String
    var firstName: String
    var lastName: String
    var fullName: String { "\(firstName) \(lastName)".capitalized }
    var email: String
    var passwordHash: String
    var createdAt: Date

    var reports: [Report] = []
    var scenarios: [Scenario] = []
    var savedReports: [UserSavedReport] = []

    
    init(
        userId: String,
        firstName: String,
        lastName: String,
        email: String,
        passwordHash: String,
        createdAt: Date = .now,
        reports: [Report] = [],
        scenarios: [Scenario] = [],
        savedReports: [UserSavedReport] = []
    )
    {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.passwordHash = passwordHash
        self.createdAt = createdAt
        self.reports = reports
        self.scenarios = scenarios
        self.savedReports = savedReports
    }
    
}
    

//Core user actions
extension User {
    
    func initiateScenario(title: String, description: String ) -> Scenario {
        return Scenario(
            scenarioId: UUID().uuidString,
            scenarioTitle: title,
            categoryId: "",
            scenarioDescription: description,
            scenarioStartNode: "",
            legalSummaryText: "",
            legalSources: [],
            updatedAt: Date()
        )
    }
    
    func generateReport(for scenario: Scenario) -> Report {
        return Report(
            reportId: UUID().uuidString,
            reportTitle: "Report for \(scenario.scenarioTitle)",
            reportDescription: "",
            contentSummary: scenario.legalSummaryText,
            storagePath: "",
            createdAt: Date(),
            updatedAt: Date(),
            user: self
        )
    }
    
    func openChat() -> ChatQuery {
        return ChatQuery(
            queryId: UUID().uuidString,
            userId: self.userId,
            queryText: "",
            responseText: nil,
            isSaved: false,
            savedAt: nil,
            tags: [],
            resourceReferences: []
        )
    }

    
    func saveReport(_ report: UserSavedReport) -> [UserSavedReport] {
        savedReports.append(report)
        return savedReports
    }
}
