//  UserSavedItem.swift
//  LegalBuddy
//
//  Created by Carolina LC on 08/10/2025.

import Foundation
import SwiftData

@Model
final class UserSavedItem {

    @Attribute(.unique) var id: String
    var userId: String
    var title: String
    var type: String
    var content: String
    var sourcesText: String?  
    var savedAt: Date

    init(
        id: String = UUID().uuidString,
        userId: String,
        title: String,
        type: String,
        content: String,
        sourcesText: String? = nil,
        savedAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.title = title
        self.type = type
        self.content = content
        self.sourcesText = sourcesText
        self.savedAt = savedAt
    }
}
