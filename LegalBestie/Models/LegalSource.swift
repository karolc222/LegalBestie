//
//  LegalSource.swift
//  LegalBuddy
//
//  Created by Carolina LC on 15/09/2025.
//

import Foundation

struct LegalSource: Identifiable, Codable {
    let id: UUID
    let title: String
    let url: String
    let description: String
    let organization: String
    let status: String
    let keywords: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case url
        case description
        case organization
        case status
        case keywords
    }
    
    init(title: String, url: String, description: String, organization: String, status: String, keywords: [String]) {
        self.id = UUID()
        self.title = title
        self.url = url
        self.description = description
        self.organization = organization
        self.status = status
        self.keywords = keywords
    }
}
