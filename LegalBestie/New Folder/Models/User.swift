//
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
    var userType: String
    var createdAt: Date
    var status: String     // active/inactive
    
    // Relationships
    var reports: [Report] = []
    var scenarios: [Scenario] = []
    var savedItems: [UserSavedItem] = []
    var chatQueries: [ChatQuery] = []
    var legalArticles: [LegalArticle] = []
    var legalCategories: [LegalCategory] = []
    
    init(
        userId: String,
        firstName: String,
        lastName: String,
        email: String,
        passwordHash: String,
        userType: String,
        createdAt: Date = .now,
        status: String = "active",
        reports: [Report] = [],
        scenarios: [Scenario] = [],
        savedItems: [UserSavedItem] = [],
        chatQueries: [ChatQuery] = [],
        legalArticles: [LegalArticle] = [],
        legalCategories: [LegalCategory] = []
    )
    {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.passwordHash = passwordHash
        self.userType = userType
        self.createdAt = createdAt
        self.status = status
        self.reports = reports
        self.scenarios = scenarios
        self.savedItems = savedItems
        self.chatQueries = chatQueries
        self.legalArticles = legalArticles
        self.legalCategories = legalCategories
    }
    
}
    

//Core user actions
extension User {
    //start new legal Scenario (skeleton instance)
    //factory method: new legal scenario session 
    func initiateScenario(title: String, description: String ) -> Scenario {
        return Scenario(
            scenarioId: UUID().uuidString,
            scenarioTitle: title,
            categoryId: "",
            scenarioDescription: description,
            scenarioStartNode: "",
           //scenarioNode: [:],
            legalSummaryText: "",
            legalSources: [],
            updatedAt: Date()
        )
    }
    
    //generate the report for scenario
    func generateReport(for scenario: Scenario ) -> Report {
        return Report(
            reportId: UUID().uuidString,
            reportType: "Scenario Summary",
            reportTitle: "Report  for \(scenario.scenarioTitle)",
            reportStatus: "draft",
            reportDescription: "",
            contentSummary: scenario.legalSummaryText,
            storagePath: "",
            createdAt: Date(),
            updatedAt: Date()
        )
    }
    
    //start chat session with AI assistant
    func openChat() -> ChatQuery {
        return ChatQuery(
            queryId: UUID().uuidString,
            userId: self.userId,
            queryText: "",
            responseText: nil,
            isSaved: false,
            savedAt: nil,
            tags: [],
            resourceReferences: [],
            //queryNotes: nil
        )
    }
    
    func browseLegalCategories(categories: [LegalCategory]) -> [LegalCategory] {
        return categories 
    }
    
    func browseLegalArticles(articles: [LegalArticle]) -> [LegalArticle] {
        return articles
    }
    
    func saveItem(_ item: UserSavedItem) -> [UserSavedItem] {
        var updatedItems = savedItems
        updatedItems.append(item)
        self.savedItems = updatedItems
        return updatedItems
    }
    
    //generate report that aggregates all saved items (notes, articles, media)
    func generateReportFromSavedItems(reportTitle: String = "Evidence & Saved Items Report") -> Report {
        let items = savedItems.sorted { $0.savedAt < $1.savedAt }
        
        //to collect report data
        var summary = ""
        
        if items.isEmpty {
            summary = "No saved items were found for this user."
        } else {
            //date formatter for readable timestamps
            let df = DateFormatter()
            df.dateStyle = .medium
            df.timeStyle = .short
            
        }
        
        // Build and return a draft Report
        return Report(
            reportId: UUID().uuidString,
            reportType: "SavedItems",
            reportTitle: reportTitle,
            reportStatus: "draft",
            reportDescription: "Compiled from the user's saved items.",
            contentSummary: summary,
            storagePath: "",
            createdAt: Date(),
            updatedAt: Date()
        )
    }
}
