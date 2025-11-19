//  EvidenceItem.swift
//  LegalBestie
//
//  Created by Carolina LC on 19/11/2025.

import Foundation
import SwiftData

enum EvidenceType: String, Codable {
    case photo
    case video
    case note
    case file
}

@Model
final class EvidenceItem {
    @Attribute(.unique)var evidenceId: String
    
    var itemType: EvidenceType
    var evidenceName: String
    var capturedAt: Date?
    var filePath: String?
    var transcription: String?
    
    init(
        evidenceId: String,
        itemType: EvidenceType,
        evidenceName: String,
        capturedAt: Date? = nil,
        filePath: String? = nil,
        transcription: String? = nil)
    {
        self.evidenceId = evidenceId
        self.itemType = itemType
        self.evidenceName = evidenceName
        self.capturedAt = capturedAt
        self.filePath = filePath
        self.transcription = transcription
    }
}
