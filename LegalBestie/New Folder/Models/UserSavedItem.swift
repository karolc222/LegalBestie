//  UserSavedItem.swift
//  LegalBestie
//
//  Created by Carolina LC on 31/12/2025

import Foundation
import SwiftData

@Model
final class UserSavedItem {
    @Attribute(.unique) var itemId: String
    var userId: String
    var itemType: String  // "article", "source", "scenario", "note"
    var itemTitle: String
    var itemContent: String?
    var itemUrl: String?
    var savedAt: Date
    
    // Relationship
    var user: User?
    
    init(
        itemId: String = UUID().uuidString,
        userId: String,
        itemType: String,
        itemTitle: String,
        itemContent: String? = nil,
        itemUrl: String? = nil,
        savedAt: Date = Date(),
        user: User? = nil
    ) {
        self.itemId = itemId
        self.userId = userId
        self.itemType = itemType
        self.itemTitle = itemTitle
        self.itemContent = itemContent
        self.itemUrl = itemUrl
        self.savedAt = savedAt
        self.user = user
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: savedAt)
    }
}
