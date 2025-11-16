//  MainTabView.swift
//  LegalBestie
//
//  Created by Carolina LC on 15/11/2025.

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomePageView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            LegalAssistantView()
                .tabItem {
                    Label("Legal Assistant", systemImage: "person")
                } 
            
            ScenarioListView(categoryName: "civil_rights")
                .tabItem {
                    Label("Scenarios", systemImage: "book")
                }
            
            /*RightsBrowserView()
                .tabItem {
                    Label("Rights", systemImage: "shield")
                }
             ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }*/
            
        }
    }
}
