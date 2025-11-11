//  LegalSource.swift
//  LegalBestie

import Foundation
import SwiftData

@Model
final class LegalSource {
    @Attribute(.unique) var sourceId: String
    var title: String
    var url: String
    var details: String
    var organization: String
    var status: String
    var keywords: [String]
    
    @Transient var urlValue: URL? {
        URL(string: url)
    }
    
    init(sourceId: String = UUID().uuidString,
         title: String,
         url: String,
         details: String,
         organization: String,
         status: String,
         keywords: [String]) {
        
        self.sourceId = sourceId
        self.title = title
        self.url = url
        self.details = details
        self.organization = organization
        self.status = status
        self.keywords = keywords
    }
}

//runtime DTO for decoding JSON
struct LegalSourceDTO: Decodable {
    let sourceId: String
    let title: String
    let url: String
    let description: String
    let organization: String
    let status: String
    let keywords: [String]
}

func loadLegalSources(from data: Data) throws -> [LegalSourceDTO] {
    try
    JSONDecoder().decode([LegalSourceDTO].self, from: data)
}

extension LegalSource {
    convenience init(dto: LegalSourceDTO) {
        self.init( sourceId: dto.sourceId,
                   title: dto.title,
                   url: dto.url,
                   details: dto.description,
                   organization: dto.organization,
                   status: dto.status,
                   keywords: dto.keywords)
    }
}
