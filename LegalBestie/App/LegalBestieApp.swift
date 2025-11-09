//
//  LegalBuddyApp.swift
//  LegalBestie
//
//  Created by Carolina LC on 23/10/2025.

import SwiftUI
import FirebaseCore
import SwiftData

@main
struct LegalBestieApp: App {
    init() {
        FirebaseApp.configure()
        
    }
    
    var body: some Scene {
        WindowGroup {
            //AuthGate()
            ScenarioListView()
        }
        
        //SwiftData container
        .modelContainer(for: [
            User.self,
            Report.self,
            Scenario.self,
            //ScenarioChoice.self,
            //UserSavedItem.self,
            ChatQuery.self,
            //LegalArticle.self,
            //LegalCategory.self
            LegalSource.self
        ])
    }
}
