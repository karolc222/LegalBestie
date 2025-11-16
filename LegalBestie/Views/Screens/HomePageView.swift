//
//  HomePageView.swift
//  LegalBestie
//
//  Created by Carolina LC on 15/11/2025.
//

import Foundation
import SwiftUI

struct HomePageView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    Text("Welcome to LegalBestie")
                        .font(.title.bold())

                    Text("Choose what you want to do today:")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    // Quick actions
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
                                title: "Legal Assistant",
                                subtitle: "Ask questions in plain language"
                            )
                        }

                        // Placeholder for future screens
                        NavigationLink {
                            Text("Rights browser coming soon")
                                .padding()
                        } label: {
                            HomeCard(
                                title: "Know Your Rights",
                                subtitle: "Browse rights by topic"
                            )
                        }

                        NavigationLink {
                            Text("Incident log coming soon")
                                .padding()
                        } label: {
                            HomeCard(
                                title: "Incident Log",
                                subtitle: "Record events and generate reports"
                            )
                        }
                    }

                    // Placeholder for recent activity
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
