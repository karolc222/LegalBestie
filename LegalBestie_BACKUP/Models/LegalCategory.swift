//  LegalCategory.swift
//  LegalBestie
//
//  Created by Carolina LC on 12/09/2025.

import Foundation
import SwiftData

@Model
final class LegalCategory {
    @Attribute(.unique) var categoryId: String
    var categoryName: String
    var categoryDescription: String
    var createdAt: Date
    var updatedAt: Date
    
    
    var sources: [LegalSource] = []
    var articles: [LegalArticle] = []
    
    init(categoryId: String, categoryName: String, categoryDescription: String, createdAt: Date,
        updatedAt: Date,
        sources: [LegalSource] = [],
        articles: [LegalArticle] = [])
    
    {
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.categoryDescription = categoryDescription
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.sources = sources
        self.articles = articles
    }
    
    
    func listSources() -> [String] {
        return sources.map { $0.sourceTitle }
    }
    
    func listArticles() -> [String] {
        return articles.map { $0.title }
    }
    
    func categorySummary() -> String {
        return "Category: \(categoryName) — \(categoryDescription)"
    }
}
