//  LegalBestieApp.swift
//  LegalBestie

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
            ChatQuery.self,
            QueryNote.self,
            ScenarioReport.self,
            StepReport.self
        ])
    }
}
