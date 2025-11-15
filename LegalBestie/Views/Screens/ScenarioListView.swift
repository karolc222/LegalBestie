//  ScenarioListView.swift
//  LegalBestie
//
//  Created by Carolina LC on 07/11/2025.

import SwiftUI
 
// minimal shape to read list metadata from each JSON
private struct ScenarioHeader: Decodable {
    let scenarioId: String
    let scenarioTitle: String
    let scenarioDescription: String
    let scenarioUpdatedAt: Date
}

// UI item (one row) in the list
private struct ScenarioListItem: Identifiable {
    let id = UUID()
    let fileName: String
    let scenarioTitle: String
    let scenarioDescription: String
    let scenarioUpdatedAt: Date
}

struct ScenarioListView: View {
    let categoryName: String
    // category passed from previous screen
    // loaded scenarios to display
    @State private var items: [ScenarioListItem] = []
    // message if loading fails
    @State private var errorText: String?
    // loading state
    @State private var isLoading = false
    
    // main UI rendering based on loading, error, or items
    var body: some View {
        Group {
            if !items.isEmpty {
                List(items) { item in
                    NavigationLink {
                        ScenarioPlayerView(
                            category: categoryName,
                            name: item.fileName
                        )
                    } label: {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(item.scenarioTitle).font(.headline)
                                Spacer()
                                Text(item.scenarioUpdatedAt.formatted(date: .abbreviated, time: .omitted))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .environment(\.locale, Locale(identifier: "en_GB"))
                            }
                            Text(item.scenarioDescription)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                                .padding(.vertical, 4)
                        }
                    }
                }
                .navigationTitle(formatCategoryName(categoryName))
                
            } else if isLoading {
                VStack(spacing: 12) {
                    ProgressView("Loading scenarios...")
                    Text("Category: \(categoryName)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } else if let msg = errorText {
                VStack(spacing: 12) {
                    Text("Failed to load").font(.headline)
                    Text(msg)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button("Retry") {
                        Task { await load() }
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            } else {
                VStack(spacing: 12) {
                    Text("No scenarios found")
                        .font(.headline)
                    Text("Category: \(categoryName)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Button("Retry") {
                        Task { await load() }
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
        }
        .task {
            if items.isEmpty && errorText == nil && !isLoading {
                await load()
            }
        }
    }
    
    // convert "civil_rights" to "Civil Rights"
    private func formatCategoryName(_ name: String) -> String {
        name.replacingOccurrences(of: "_", with: " ")
            .capitalized
    }
    
    // JSON decoder using UK date format
    private func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        let df = DateFormatter()
        df.calendar = .init(identifier: .iso8601)
        df.locale = .init(identifier: "en_GB")
        df.timeZone = .init(secondsFromGMT: 0)
        df.dateFormat = "dd-MM-yyyy"
        decoder.dateDecodingStrategy = .formatted(df)
        return decoder
    }
    
    // fetch and decode all scenario JSON files
    private func load() async {
        await MainActor.run {
            isLoading = true
            errorText = nil
            items = []
        }
        
        // list all .json files in bundle root
        let urls = Bundle.main.urls(
            forResourcesWithExtension: "json",
            subdirectory: nil
        ) ?? []
        
        if urls.isEmpty {
            await MainActor.run {
                errorText = "No JSON files found."
                isLoading = false
            }
            return
        }
        
        let decoder = makeDecoder()
        var result: [ScenarioListItem] = []
        // try decoding each JSON into a ScenarioHeader
        for url in urls {
            guard
                let data = try? Data(contentsOf: url),
                let header = try? decoder.decode(ScenarioHeader.self, from: data)
            else {
                continue
            }
            
            let fileName = url.deletingPathExtension().lastPathComponent
            
            result.append(
                ScenarioListItem(
                    fileName: fileName,
                    scenarioTitle: header.scenarioTitle,
                    scenarioDescription: header.scenarioDescription,
                    scenarioUpdatedAt: header.scenarioUpdatedAt
                )
            )
        }
        
        if result.isEmpty {
            await MainActor.run {
                errorText = "Scenario files could not be decoded."
                isLoading = false
            }
            return
        }
        
        // sort scenarios alphabetically
        let sorted = result.sorted {
            $0.scenarioTitle.localizedCaseInsensitiveCompare($1.scenarioTitle) == .orderedAscending
        }
        
        // update UI with results
        await MainActor.run {
            items = sorted
            isLoading = false
        }
    }
}

#Preview {
    NavigationStack {
        ScenarioListView(categoryName: "civil_rights")
    }
}
