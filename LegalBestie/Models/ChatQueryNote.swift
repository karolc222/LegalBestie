//  ChatQueryNote.swift
//  LegalBestie
//
//  Created by Carolina LC on 16/10/2025.

import Foundation
import SwiftData

@Model
final class QueryNote {
    @Attribute(.unique) var noteId: String
    var noteType: String
    var content: String
    var linkedArticleID: String?
    var linkedSourceID: String?
    var createdAt: Date
    
    @Relationship(inverse: \ChatQuery.queryNotes)
    var chatQuery: ChatQuery?
    
    
    init(noteId: String = UUID().uuidString, chatQuery: ChatQuery? = nil, noteType: String, content: String, linkedArticleID: String? = nil, linkedSourceID: String? = nil, createdAt: Date) {
        self.noteId = noteId
        self.chatQuery = chatQuery
        self.noteType = noteType
        self.content = content
        self.linkedArticleID = linkedArticleID
        self.linkedSourceID = linkedSourceID
        self.createdAt = createdAt
        self.noteType = noteType
        self.content = content
    }
    
    @Transient var displayContent: String {
        return content
    }
    

    func displayNote() -> String {
        return "[\(noteType.capitalized)] \(content)"
    }

    func isLinked() -> Bool {
        return linkedArticleID != nil || linkedSourceID != nil
    }

    func containsKeyword(_ keyword: String) -> Bool {
        return content.lowercased().contains(keyword.lowercased())
    }
}
