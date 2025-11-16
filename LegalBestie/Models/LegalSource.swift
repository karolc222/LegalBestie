//  LegalSource.swift
//  LegalBestie

import Foundation
import SwiftData

@Model
final class LegalSource {
    @Attribute(.unique) var sourceId: String
    var sourceTitle: String
    var sourceUrl: String
    var sourceDescription: String
    var sourceOrganization: String
    var sourceStatus: String
    var sourceKeywords: [String]
    var sourceTopics: [String]
    
    @Transient var urlValue: URL? {
        URL(string: sourceUrl)
    }
    
    init(sourceId: String = UUID().uuidString,
         sourceTitle: String,
         sourceUrl: String,
         sourceDescription: String,
         sourceOrganization: String,
         sourceStatus: String,
         sourceKeywords: [String],
         sourceTopics: [String])
    {
        
        self.sourceId = sourceId
        self.sourceTitle = sourceTitle
        self.sourceUrl = sourceUrl
        self.sourceDescription = sourceDescription
        self.sourceOrganization = sourceOrganization
        self.sourceStatus = sourceStatus
        self.sourceKeywords = sourceKeywords
        self.sourceTopics = sourceTopics
    }
}
    
    extension LegalSource {
        convenience init(dto: LegalSourceDTO) {
            self.init(
                sourceId: UUID().uuidString,
                sourceTitle: dto.sourceTitle,
                sourceUrl:dto.sourceUrl.absoluteString,
                sourceDescription: dto.sourceDescription,
                sourceOrganization: dto.sourceOrganization ?? "",
                sourceStatus: dto.sourceStatus ?? "",
                sourceKeywords: dto.sourceKeywords ?? [],
                sourceTopics: dto.topics ?? []
            )
        }
    }

