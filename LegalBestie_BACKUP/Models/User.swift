//  User.swift
//  LegalBestie
//
//  Created by Carolina LC on 08/10/2025.


import Foundation
import SwiftData

@Model final class User {
    @Attribute(.unique) var userId: String
    var firstName: String
    var lastName: String
    var fullName: String { "\(firstName) \(lastName)".capitalized }
    var email: String
    var createdAt: Date

    init(
        userId: String,
        firstName: String,
        lastName: String,
        email: String,
        createdAt: Date = .now
    ) {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.createdAt = createdAt
    }
}
