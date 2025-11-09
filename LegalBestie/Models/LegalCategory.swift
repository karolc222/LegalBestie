//
//  LegalCategory.swift
//  LegalBestie
//
//  Created by Carolina LC on 12/09/2025.
//

import Foundation

struct LegalCategory: Identifiable {
    let id: String
    let name: String
    let description: String
    let createdAt: Date
    let updatedAt: Date
    

    // Relationships
    var sources: [LegalSource]?
    //var articles: [LegalArticle]?


    func listSources() -> [String] {
        return sources?.map { $0.title } ?? []
    }

    /*func listArticles() -> [String] {
        return articles?.map { $0.title } ?? []
    }*/

    func categorySummary() -> String {
        return "Category: \(name) — \(description)"
    }
}
