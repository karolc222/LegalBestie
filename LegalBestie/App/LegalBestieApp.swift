//  LegalBestieApp.swift
//  LegalBestie
//
//  Created by Carolina LC on 23/10/2025.

import SwiftUI
import Firebase

@main
struct LegalBestieApp: App {

    @StateObject private var authService = AuthService()

    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            AuthGate()
                .environmentObject(authService)
        }
        .modelContainer(for: [
            UserSavedReport.self,
            ScenarioReport.self,
            StepReport.self ])
    }
}
