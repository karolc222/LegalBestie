//  UserSavedItem.swift
//  LegalBuddy
//
//  Created by Carolina LC on 08/10/2025.

import Foundation

struct UserSavedItem: Codable, Identifiable {
    let savedItemId: String
    let userId: String
    let itemTitle: String
    let itemType: String       //"article", "note", "query"
    let itemContent: String
    let mediaType: String?
    let storagePath: String?  //file or URL path
    let fileSize: Double?
    let durationSeconds: Double?
    let thumbnailPath: String?
    let transcription: String?
    let itemTags: [String]?  //keywords or hashtags
    let savedAt: Date
    
    var id: String {savedItemId}

    // MARK: - Methods
    func displayInfo() -> String {
        return "\(itemType.capitalized): \(itemTitle)"
    }

    func containsKeyword(_ keyword: String) -> Bool {
        let k = keyword.lowercased()
        return itemTitle.lowercased().contains(k)
            || itemContent.lowercased().contains(k)
            || (transcription?.lowercased().contains(k) ?? false)
            || (itemTags?.contains { $0.lowercased().contains(k) } ?? false)
    }
}
