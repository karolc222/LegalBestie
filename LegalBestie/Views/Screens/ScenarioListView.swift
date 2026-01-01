//  ScenarioListView.swift
//  LegalBestie
//
//  Created by Carolina LC on 07/11/2025.

import SwiftUI

struct ScenarioListView: View {
    let categoryName: String
    
    @StateObject private var viewModel = ScenarioListViewModel()
    @EnvironmentObject var auth: AuthService
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading...")
                
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Text("Failed to load")
                        .font(.headline)
                    Text(error)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Button("Retry") {
                        Task { await viewModel.loadScenarios() }
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
                
            } else {
                List(viewModel.scenarios) { scenario in
                    NavigationLink {
                        ScenarioPlayerView(category: categoryName, name: scenario.fileName)
                        
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(scenario.title)
                                .font(.headline)
                            Text(scenario.description)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle(categoryName.replacingOccurrences(of: "_", with: " ").capitalized)
        .task {
            await viewModel.loadScenarios()
        }
    }
}
