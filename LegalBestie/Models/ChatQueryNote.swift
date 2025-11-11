//  ChatQueryNote.swift
//  LegalBestie
//
//  Created by Carolina LC on 16/10/2025.

import Foundation

struct QueryNote: Codable, Identifiable {
    let id: String
    let chatQueryID: String
    let noteType: String        // e.g., "article", "chatResponse", "link"
    let content: String
    let linkedArticleID: String?
    let linkedSourceID: String?
    let createdAt: Date

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
