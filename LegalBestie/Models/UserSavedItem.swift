//  UserSavedItem.swift
//  LegalBuddy
//
//  Created by Carolina LC on 08/10/2025.

import Foundation
import SwiftData

@Model
final class UserSavedItem {
    var savedItemId: String
    var userId: String
    var itemTitle: String
    var itemType: String       //"article", "note", "query"
    var itemContent: String
    var mediaType: String?
    var storagePath: String?  //file or URL path
    var fileSize: Double?
    var durationSeconds: Double?
    var thumbnailPath: String?
    var transcription: String?
    var itemTags: [String]?  //keywords or hashtags
    var savedAt: Date
    
    var id: String {savedItemId}
    
    init(savedItemId: String, userId: String, itemTitle: String, itemType: String, itemContent: String, mediaType: String? = nil, storagePath: String? = nil, fileSize: Double? = nil, durationSeconds: Double? = nil, thumbnailPath: String? = nil, transcription: String? = nil, itemTags: [String]? = nil, savedAt: Date) {
        self.savedItemId = savedItemId
        self.userId = userId
        self.itemTitle = itemTitle
        self.itemType = itemType
        self.itemContent = itemContent
        self.mediaType = mediaType
        self.storagePath = storagePath
        self.fileSize = fileSize
        self.durationSeconds = durationSeconds
        self.thumbnailPath = thumbnailPath
        self.transcription = transcription
        self.itemTags = itemTags
        self.savedAt = savedAt
    }

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
