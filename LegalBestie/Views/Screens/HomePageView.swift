//  HomePageView.swift
//  LegalBestie
//
//  Created by Carolina LC on 15/11/2025.


import SwiftUI
private let brandRose = Color(red: 0.965, green: 0.29, blue: 0.54)

struct HomePageView: View {
    let user: User?
    let isGuest: Bool
    let onSignOut: () -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [brandRose.opacity(0.10), Color(.systemBackground)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                List {
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(isGuest ? "Welcome" : "Welcome back")
                            .font(.title.weight(.semibold))

                        if !isGuest, let email = user?.email {
                            Text(email)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 6)
                }
                .listRowBackground(Color.clear)

                    
                    
                Section {
                    NavigationLink {
                        ScenarioListView(categoryName: "all")
                    } label: {
                        HomeLabel(
                            title: "Interactive Scenarios",
                            subtitle: "Practice real-life situations step by step",
                            systemImage: "list.bullet.rectangle"
                        )
                    }

                    
                    
                    NavigationLink {
                        LegalAssistantView()
                    } label: {
                        HomeLabel(
                            title: "AI Legal Assistant",
                            subtitle: "Ask questions and get source-based answers.",
                            systemImage: "bubble.left.and.bubble.right"
                        )
                    }

                    if isGuest {
                        Button {
                            onSignOut()
                        } label: {
                            HomeLabel(
                                title: "Register",
                                subtitle: "Create an account to save your work.",
                                systemImage: "person.badge.plus"
                            )
                        }
                    } else {
                        NavigationLink {
                            SavedReportsView()
                        } label: {
                            HomeLabel(
                                title: "Saved Library",
                                subtitle: "View saved scenario reports and assistant answers",
                                systemImage: "folder"
                            )
                        }
                    }
                }
            }
            .navigationTitle("Home")
            .scrollContentBackground(.hidden)
            .listStyle(.insetGrouped)
            }
        }
    }
    
    struct HomeLabel: View {
        let title: String
        let subtitle: String
        let systemImage: String
        
        var body: some View {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(brandRose.opacity(0.15))
                        .frame(width: 35, height: 35)
                    
                    Image(systemName: systemImage)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(brandRose)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.secondarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(brandRose.opacity(0.18), lineWidth: 1))
        }
    }
    
}
