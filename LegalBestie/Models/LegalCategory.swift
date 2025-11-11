//  LegalCategory.swift
//  LegalBestie
//
//  Created by Carolina LC on 12/09/2025.

import Foundation
import SwiftData

@Model
final class LegalCategory {
    var id: String
    var name: String
    var categoryDescription: String
    var createdAt: Date
    var updatedAt: Date
    
    
    // Relationships
    var sources: [LegalSource] = []
    var articles: [LegalArticle] = []
    
    init(id: String, name: String, categoryDescription: String, createdAt: Date, updatedAt: Date, sources: [LegalSource] = [], articles: [LegalArticle] = []) {
        self.id = id
        self.name = name
        self.categoryDescription = categoryDescription
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.sources = sources
        self.articles = articles
    }
    
    
    func listSources() -> [String] {
        return sources.map { $0.title }
    }
    
    func listArticles() -> [String] {
        return articles.map { $0.title }
    }
    
    func categorySummary() -> String {
        return "Category: \(name) — \(categoryDescription)"
    }
}
