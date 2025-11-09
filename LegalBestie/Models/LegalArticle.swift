//
//  LegalArticle.swift
//  LegalBuddy
//
//  Created by Carolina LC on 08/10/2025.
//

import Foundation

struct LegalArticle: Identifiable {
    let id: String
    let title: String
    let summary: String
    let fullText: String
    let references: [String]?
    let createdAt: Date
    let updatedAt: Date
    
    // Relationships
    let source: LegalSource
    let categories: [LegalCategory]?
    
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

