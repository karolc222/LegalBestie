//  ScenarioListView.swift
//  LegalBestie
//
//  Created by Carolina LC on 07/11/2025.

import SwiftUI

private let brandRose = Color(red: 0.965, green: 0.29, blue: 0.54)

struct ScenarioListView: View {
    let categoryName: String
    
    @StateObject private var viewModel = ScenarioListViewModel()
    
    
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [brandRose.opacity(0.10), Color(.systemBackground)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            
            Group {
                if viewModel.isLoading {
                    VStack(spacing: 10) {
                        ProgressView()
                        Text("Loading scenarios...")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()

                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 12) {
                        Text("Failed to load")
                            .font(.headline)

                        Text(error)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)

                        Button("Retry") {
                            Task { await viewModel.loadScenarios() }
                        }
                        .buttonStyle(.bordered)
                        .tint(brandRose)
                    }
                    .padding()

                    
                } else {
                    List(viewModel.scenarios) { scenario in
                        NavigationLink {
                            ScenarioPlayerView(category: categoryName, name: scenario.fileName)
                            
                        } label: {
                            HStack(alignment: .top, spacing: 0) {

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(scenario.title)
                                        .font(.headline)

                                    Text(scenario.description)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(2)
                                }

                                Spacer(minLength: 0)
                            }
                            .padding(.vertical, 14)
                            .padding(.horizontal, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Color(.secondarySystemBackground))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(brandRose.opacity(0.18), lineWidth: 1)
                            )
                        }
                        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        .listRowBackground(Color.clear)
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.insetGrouped)
                }
            }
        }
        
        .navigationTitle(categoryName.replacingOccurrences(of: "_", with: " ").capitalized)
        .task {
            await viewModel.loadScenarios()
        }
    }
}
