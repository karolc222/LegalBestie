//  UserResponse.swift
//  LegalBestie
//
//  Created by Carolina LC on 18/11/2025.


import Foundation

struct UserResponse: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

