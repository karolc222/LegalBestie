//  MainTabView.swift
//  LegalBestie

import SwiftUI

struct MainTabView: View {
    let user: AuthService.AppUser
    let isGuest: Bool
    let onSignOut: () -> Void

    var body: some View {
        TabView {
            
            //Home tab
            HomePageView(user: user, isGuest: isGuest, onSignOut: onSignOut)
            .tabItem {
                Label("Home", systemImage: "house")
            }

            // Scenarios Tab
            ScenarioListView(categoryName: "civil_rights")
                .tabItem {
                    Label("Scenarios", systemImage: "list.bullet.rectangle")
                }

            // Assistant Tab
            LegalAssistantView()
                .tabItem {
                    Label("Assistant", systemImage: "bubble.left.and.bubble.right")
                }

            // Profile Tab
            if isGuest {
                GuestProfileView(onSignIn: onSignOut)
                    .tabItem {
                        Label("GuestProfile", systemImage: "person")
                    }
            } else {
                ProfileView(user: user, onSignOut: onSignOut)
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
            }
        }
    }
}
