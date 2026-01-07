//  SourceDTO.swift
//  LegalBestie
//
//  Created by Carolina LC on 21/12/2025.

import Foundation

struct SourceDTO: Decodable, Identifiable {
    let id: UUID
    let sourceTitle: String
    let sourceDescription: String
    let sourceUrl: String
    let sourceKeywords: [String]
    let sourceTopics: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case sourceTitle
        case sourceDescription
        case sourceUrl
        case sourceKeywords
        case sourceTopics
    }
}
