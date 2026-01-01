//  ChatQuery.swift
//  LegalBestie
//
//  Created by Carolina LC on 16/10/2025.

import Foundation
import SwiftData

@Model
final class ChatQuery {
    @Attribute(.unique) var queryId: String
    var id: String { queryId }
    var userId: String
    var queryText: String
    var responseText: String?
    var isSaved: Bool
    var savedAt: Date?
    var tags: [String]?
    var resourceReferences: [String]?

    @Relationship(deleteRule: .cascade)
    var queryNotes: [QueryNote] = []
    
    init(
        queryId: String = UUID().uuidString,
        userId: String,
        queryText: String,
        responseText: String? = nil,
        isSaved: Bool = false,
        savedAt: Date? = nil,
        tags: [String]? = nil,
        resourceReferences: [String]? = nil,
        queryNotes: [QueryNote]? = nil
    )
    {
        self.queryId = queryId
        self.userId = userId
        self.queryText = queryText
        self.responseText = responseText
        self.isSaved = isSaved
        self.savedAt = savedAt
        self.tags = tags
        self.resourceReferences = resourceReferences
        //self.queryNotes = [QueryNote]
    }

    func savedQuery() {
        isSaved = true
        savedAt = Date()
    }

    func containsKeyword(_ keyword: String) -> Bool {
        return queryText.lowercased().contains(keyword.lowercased()) ||
               (responseText?.lowercased().contains(keyword.lowercased()) ?? false)
    }

    func displaySummary() -> String {
        let responsePreview = responseText?.prefix(60) ?? "No response yet"
        return "Query: \(queryText) → \(responsePreview)"
    }
}
