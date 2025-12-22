//  HomePageView.swift
//  LegalBestie
//
//  Created by Carolina LC on 15/11/2025.

import SwiftUI

struct HomePageView: View {
    let user: AuthService.AppUser
    let onSignOut: () -> Void

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

                        NavigationLink {
                            ProfileView(user: user, onSignOut: onSignOut)
                        } label: {
                            HomeCard(
                                title: "My Profile",
                                subtitle: "Personal info and saved content"
                            )
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Saved Library")
                            .font(.headline)
                        Text("Your saved scenario reports and assistant answers will appear here.")
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

struct HomeCard: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial)
        .cornerRadius(16)
    }
}

// Temporary placeholder until the dedicated SavedReportsView screen is integrated in the target.
struct SavedReportsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Saved Library")
                .font(.title2.bold())
            Text("Saved scenario reports and assistant answers will appear here.")
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Saved")
    }
}
