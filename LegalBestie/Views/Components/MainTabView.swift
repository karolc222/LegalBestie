//  MainTabView.swift
//  LegalBestie

import SwiftUI

struct MainTabView: View {
    let user: AuthService.AppUser?
    let onSignOut: () -> Void

    init(user: AuthService.AppUser? = nil, onSignOut: @escaping () -> Void = {}) {
        self.user = user
        self.onSignOut = onSignOut
    }

    var body: some View {
        TabView {
            // Home Tab
            Group {
                if let u = user {
                    HomePageView(user: u, onSignOut: onSignOut)
                } else {
                    HomePagePlaceholderView()
                }
            }
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
            Group {
                if let u = user {
                    ProfileView(user: u, onSignOut: onSignOut)
                } else {
                    ProfilePlaceholderView()
                }
            }
            .tabItem {
                Label("Profile", systemImage: "person")
            }
        }
    }
}

// MARK: - Placeholder Views

struct HomePagePlaceholderView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    Text("Welcome to LegalBestie")
                        .font(.title.bold())

                    Text("Choose what you want to do today:")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    VStack(spacing: 12) {
                        NavigationLink {
                            ScenarioListView(categoryName: "all")
                        } label: {
                            HomeCard(
                                title: "Interactive Scenarios",
                                subtitle: "Practice real-life situations step by step"
                            )
                        }

                        NavigationLink {
                            LegalAssistantView()
                        } label: {
                            HomeCard(
                                title: "AI Legal Assistant",
                                subtitle: "Ask questions and get source-based answers"
                            )
                        }

                        NavigationLink {
                            SavedReportsView()
                        } label: {
                            HomeCard(
                                title: "Saved Library",
                                subtitle: "View saved scenario reports and assistant answers"
                            )
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Recent activity")
                            .font(.headline)
                        Text("Your recent scenarios and notes will appear here.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
            }
            .navigationTitle("Home")
        }
    }
}

struct ProfilePlaceholderView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Profile") {
                    Text("Sign-in is disabled for this demo run.")
                        .foregroundStyle(.secondary)
                }

                Section("Saved") {
                    NavigationLink {
                        SavedReportsView()
                    } label: {
                        Text("Saved Library")
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}
