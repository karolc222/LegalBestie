//
//  LegalBuddyApp.swift
//  LegalBuddy
//
//  Created by Carolina LC on 23/10/2025.
//
import SwiftUI
import FirebaseCore

@main
struct LegalBuddyApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            AuthGate()
        }
    }
}
