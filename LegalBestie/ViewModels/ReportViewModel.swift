//  ReportViewModel.swift
//  LegalBestie
//
//  Created by Carolina LC on 02/11/2025.


import Foundation
import SwiftUI
import SwiftData

enum AppError: LocalizedError {
    case signInRequired
    case notFound
    case saveFailed
    
    var errorDescription: String? {
        switch self {
        case .signInRequired:
            return "Sign in required."
        case .notFound:
            return "Item not found."
        case .saveFailed:
            return "Save failed."
        }
    }
}




