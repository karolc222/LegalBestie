//  ScenarioPlayerView.swift
//  LegalBestie
//
//  JSON decoder + player (parametric)

import SwiftUI

// Runtime Codable structs to decode JSON into memory
private struct ScenarioTemplate: Codable {
    let scenarioId: String
    let scenarioTitle: String
    let categoryName: String
    let scenarioDescription: String
    let startNode: String
    let nodes: [String: Node]
    let legalSummaryText: String
    let legalSources: [ScenarioSourceDTO]?
    let scenarioUpdatedAt: Date?
}

private struct Node: Codable {
    let question: String
    let choices: [ScenarioChoiceDTO]?   // optional so leaf nodes can omit choices
}

private struct ScenarioChoiceDTO: Codable, Hashable {
    let label: String
    let nextNode: String
}

private struct ScenarioSourceDTO: Codable, Hashable {
    let sourceId: String
    let scenarioTitle: String
    let scenarioLink: URL
}

// Decoder and loader
private func makeScenarioDecoder() -> JSONDecoder {
    let dec = JSONDecoder()
    // Decode dates like "09-11-2025" in British time
    let df = DateFormatter()
    df.calendar = Calendar(identifier: .iso8601)
    df.locale = Locale(identifier: "en_GB")
    df.timeZone = TimeZone(identifier: "Europe/London")
    df.dateFormat = "dd-MM-yyyy"
    dec.dateDecodingStrategy = .formatted(df)
    return dec
}

private func loadTemplate(category: String, name: String) throws -> ScenarioTemplate {
    guard let url = Bundle.main.url(
        forResource: name,
        withExtension: "json",
        subdirectory: nil
    ) else {
        throw NSError(
            domain: "ScenarioPlayer",
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: "Template not found: \(name).json"]
        )
    }
    let data = try Data(contentsOf: url)
    return try makeScenarioDecoder().decode(ScenarioTemplate.self, from: data)
}

//View state + initializer
struct ScenarioPlayerView: View {
    let category: String
    let name: String

    @State private var template: ScenarioTemplate?
    @State private var currentKey: String = ""
    @State private var errorText: String?

    var body: some View {
        NavigationStack {
            Group {
                if let template, let node = template.nodes[currentKey] {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(template.scenarioTitle).font(.title2).bold()
                        
                        Text(node.question).font(.headline)

                        if let choices = node.choices, !choices.isEmpty {
                            ForEach(choices, id: \.self) { c in
                                Button(c.label) { currentKey = c.nextNode }
                                    .buttonStyle(.borderedProminent)
                            }
                        } else {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Outcome reached").font(.subheadline)
                                Text(template.legalSummaryText)
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Spacer(minLength: 0)

                        HStack {
                            Text("Last updated")
                            Text(
                                (template.scenarioUpdatedAt ?? .now).formatted(date: .abbreviated, time: .shortened)
                            )
                            .environment(\.locale, Locale(identifier: "en_GB"))
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    .padding()
                } else if let errorText {
                    VStack(spacing: 12) {
                        Text("Failed to load scenario").font(.headline)
                        Text(errorText).font(.caption).foregroundStyle(.secondary)
                        Button("Retry") { load() }.buttonStyle(.bordered)
                    }
                    .padding()
                } else {
                    ProgressView()
                }
            }
            .task { load() }
            .navigationTitle("Scenario")
        }
    }

    // Load on appear
    private func load() {
        do {
            let t = try loadTemplate(category: category, name: name)
            template = t
            currentKey = t.startNode
        } catch {
            errorText = error.localizedDescription
        }
    }
}

// Preview
#Preview {
    ScenarioPlayerView(category: "Civil rights", name: "stopped_by_police")
}
