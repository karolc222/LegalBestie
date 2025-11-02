//
//  ChatQuery.swift
//  LegalBuddy
//
//  Created by Carolina LC on 16/10/2025.
//

import Foundation

struct ChatQuery: Codable, Identifiable {
    let queryId: String
    var id: String { queryId }
    let userId: String
    let queryText: String
    let responseText: String?
    let isSaved: Bool
    let savedAt: Date?
    let tags: [String]?
    let resourceReferences: [String]?

    // Relationships
    var queryNotes: [QueryNote]?

    // MARK: - Methods
    func saveQuery() -> ChatQuery {
        return ChatQuery(
            queryId: queryId,
            userId: userId,
            queryText: queryText,
            responseText: responseText,
            isSaved: true,
            savedAt: Date(),
            tags: tags,
            resourceReferences: resourceReferences,
            queryNotes: queryNotes
        )
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
