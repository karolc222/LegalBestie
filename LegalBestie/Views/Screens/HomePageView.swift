//  HomePageView.swift
//  LegalBestie
//
//  Created by Carolina LC on 15/11/2025.

import SwiftUI

struct HomePageView: View {
    let user: AuthService.AppUser
    let isGuest: Bool
    let onSignOut: () -> Void
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        if isGuest {
                            Text("Welcome")
                                .font(.title.bold())
                        } else {
                            Text("Welcome Back")
                                .font(.title.bold())
                            
                            if let email = user.email {
                                Text(email)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                .listRowBackground(Color.clear)
                
                
                // Main cards
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
                                title:"Register",
                                subtitle: "Create an account to save your work.",
                                systemImage: "person.badge.plus")
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
            }
        }
    }
    
    struct HomeLabel: View {
        let title: String
        let subtitle: String
        let systemImage: String
        
        var body: some View {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .font(.title2)
                    .foregroundStyle(.pink)
                    .frame(width: 32)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 4)
            
        }
        }
    
