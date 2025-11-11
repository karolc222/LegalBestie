//  LegalArticle.swift
//  LegalBestie
//
//  Created by Carolina LC on 08/10/2025.

import Foundation
import SwiftData

@Model
final class LegalArticle {
    @Attribute(.unique) var articleId: String
    var title: String
    var summary: String
    var fullText: String
    var references: [String]
    var createdAt: Date
    var updatedAt: Date

    // Relationships
    var source: LegalSource
    var categories: [LegalCategory]
    
    init(
        articleId: String,
        title: String,
        summary: String,
        fullText: String,
        references: [String] = [],
        createdAt: Date,
        updatedAt: Date,
        source: LegalSource,
        categories: [LegalCategory] = []
    ) {
        self.articleId = articleId
        self.title = title
        self.summary = summary
        self.fullText = fullText
        self.references = references
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.source = source
        self.categories = categories
    }
    
    func getArticleSummary() -> String {
        return summary
    }
    
    func fetchSourceMetadata() -> String {
        return "Source: \(source.title)"
        }
        
        func linkToCategory(_ category: LegalCategory) -> String {
            return "Linked to category: \(category.name)"
        }
    }
