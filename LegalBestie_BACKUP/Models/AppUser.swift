//  AppUser.swift
//  LegalBestie
//
//  Created by Carolina LC on 03/01/2026.

import Foundation

struct AppUser: Identifiable, Equatable {
    let id: String
    let email: String?
    let isVerified: Bool
}
