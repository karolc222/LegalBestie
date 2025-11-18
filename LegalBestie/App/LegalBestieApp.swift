//  LegalBestieApp.swift
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
            NavigationStack {
                //ScenarioPlayerView(category: "Civil rights", name: "stopped_by_police")
                //AuthGate()
                //ScenarioListView(categoryName: "civil_rights")
                MainTabView()
            }
        }
        
        //SwiftData container
        .modelContainer(for: [
            User.self,
            Report.self,
            Scenario.self,
            UserSavedItem.self,
            ChatQuery.self,
            QueryNote.self,
            LegalArticle.self,
            LegalCategory.self,
            LegalSource.self,
            ScenarioChoiceModel.self
            
        ])
    }
}
