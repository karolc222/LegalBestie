//  MainTabView.swift
//  LegalBestie

import SwiftUI

private let brandRose = Color(red: 0.965, green: 0.29, blue: 0.54)


struct MainTabView: View {
    let user: AuthService.AppUser
    let isGuest: Bool
    let onSignOut: () -> Void

    var body: some View {
        TabView {
            HomePageView(user: user, isGuest: isGuest, onSignOut: onSignOut)
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            ScenarioListView(categoryName: "civil_rights")
                .tabItem {
                    Label("Scenarios", systemImage: "list.bullet.rectangle")
                }

            LegalAssistantView()
                .tabItem {
                    Label("Assistant", systemImage: "bubble.left.and.bubble.right")
                }

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
        .tint(brandRose)
    }
}
