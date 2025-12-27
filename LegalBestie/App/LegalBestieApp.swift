//  LegalBestieApp.swift
//  LegalBestie

import SwiftUI
import Firebase

@main
struct LegalBestieApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
                AuthGate()
            }
        }
    }

