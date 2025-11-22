//  ScenarioPlayerView.swift
//  LegalBestie
//
//  JSON decoder + player with answer tracking

import SwiftUI
import SwiftData

// Runtime Codable structs to decode JSON into memory
struct ScenarioTemplate: Codable {
    let scenarioId: String
    let scenarioTitle: String
    let categoryName: String
    let scenarioDescription: String
    let startNode: String
    let nodes: [String: Node]
    let legalSummaryText: String
    let legalSources: [ScenarioSourceDTO]?
    let scenarioUpdatedAt: Date?
    let scenarioTopics: [String]
}

struct Node: Codable {
    let question: String
    let choices: [ScenarioChoiceDTO]?
}

struct ScenarioChoiceDTO: Codable, Hashable {
    let label: String
    let nextNode: String
}

struct ScenarioSourceDTO: Codable, Hashable, Identifiable {
    let sourceId: String
    let sourceTitle: String
    let sourceLink: URL      
    let sourceDescription: String
    let sourceOrganization: String
    let sourceStatus: String
    let scenarioTopics: [String]
    
    var id: String { sourceId }
}

// Decoder and loader
private func makeScenarioDecoder() -> JSONDecoder {
    let dec = JSONDecoder()
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

// Main View
struct ScenarioPlayerView: View {
    let category: String
    let name: String
    
    @Environment(\.modelContext) private var modelContext

    @State private var template: ScenarioTemplate?
    @State private var currentKey: String = ""
    @State private var errorText: String?
    @State private var showOutcome = false
    
    // Track user responses
    @State private var userResponses: [UserResponse] = []
    @State private var report: ScenarioReport?

    var body: some View {
        NavigationStack {
            Group {
                if let template, let node = template.nodes[currentKey] {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(template.scenarioTitle)
                            .font(.title2.bold())
                        
                        // Progress indicator
                        if !userResponses.isEmpty {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                                Text("\(userResponses.count) questions answered")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                        
                        if let choices = node.choices, !choices.isEmpty {
                            // Question + choices UI
                            Text(node.question)
                                .font(.headline)
                                .padding(.vertical, 8)
                            
                            ForEach(choices, id: \.self) { choice in
                                Button(choice.label) {
                                    // Record the answer
                                    recordAnswer(question: node.question, answer: choice.label)
                                    // Move to next node
                                    currentKey = choice.nextNode
                                }
                                .buttonStyle(.borderedProminent)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                        } else {
                            // Outcome reached UI
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Scenario Complete")
                                    .font(.title3.bold())
                                
                                Text(node.question)
                                    .font(.body)
                                
                                Button {
                                    generateReport()
                                    showOutcome = true
                                } label: {
                                    Label("View Summary & Generate Report", systemImage: "doc.text")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            .padding()
                        }

                        Spacer(minLength: 0)

                        HStack {
                            Text("Last updated")
                            Text(
                                (template.scenarioUpdatedAt ?? .now)
                                    .formatted(date: .abbreviated, time: .omitted)
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
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $showOutcome) {
                if let template, let report {
                    ScenarioOutcomeView(
                        scenarioTitle: template.scenarioTitle,
                        scenarioDescription: template.scenarioDescription,
                        legalSummary: template.legalSummaryText,
                        topics: template.scenarioTopics,
                        scenarioSources: template.legalSources ?? [],
                        report: report
                    )
                } else {
                    Text("No scenario data")
                }
            }
        }
    }

    // Load scenario
    private func load() {
        do {
            let t = try loadTemplate(category: category, name: name)
            template = t
            currentKey = t.startNode
        } catch {
            errorText = error.localizedDescription
        }
    }
    
    // Record user's answer
    private func recordAnswer(question: String, answer: String) {
        let response = UserResponse(question: question, answer: answer)
        userResponses.append(response)
    }
    
    // Generate report from answers
    private func generateReport() {
        guard let template else { return }
        
        // Convert responses to StepReports with statements
        let steps = userResponses.map { response in
            let statement = convertToStatement(question: response.question, answer: response.answer)
            return StepReport(
                scenarioId: template.scenarioId,
                question: response.question,
                userAnswer: response.answer,
                statement: statement
            )
        }
        
        // Convert ScenarioSourceDTO to LegalSource for report
        let sources = (template.legalSources ?? []).map { dto in
            LegalSource(
                sourceTitle: dto.sourceTitle,
                sourceUrl: dto.sourceLink.absoluteString,
                sourceDescription: dto.sourceDescription,
                sourceOrganization: dto.sourceOrganization,
                sourceStatus: dto.sourceStatus,
                sourceKeywords: [],
                sourceTopics: dto.scenarioTopics
            )
        }
        
        // Create report
        report = ScenarioReport(
            userName: "User", // You can get this from auth later
            scenarioId: template.scenarioId,
            scenarioTitle: template.scenarioTitle,
            createdAt: Date(),
            updatedAt: Date(),
            status: "completed",
            steps: steps,
            legalSummary: template.legalSummaryText,
            legalSources: sources
        )
        
        // Save to SwiftData
        if let report {
            modelContext.insert(report)
            try? modelContext.save()
        }
    }
    
    // Convert question + answer to statement
    private func convertToStatement(question: String, answer: String) -> String {
        let choice = answer.lowercased()
        var statement = question.replacingOccurrences(of: "?", with: "").trimmingCharacters(in: .whitespaces)
        
        if choice == "yes" {
            statement = statement.replacingOccurrences(of: "Did the ", with: "The ")
            statement = statement.replacingOccurrences(of: "Did ", with: "")
            statement = statement.replacingOccurrences(of: "Did your ", with: "My ")
            statement = statement.replacingOccurrences(of: "Were you ", with: "I was ")
            statement = statement.replacingOccurrences(of: "Was the ", with: "The ")
            statement = statement.replacingOccurrences(of: "Was your ", with: "My ")
            statement = statement.replacingOccurrences(of: "Does the ", with: "The ")
            
            // Convert verbs to past tense
            statement = statement.replacingOccurrences(of: " ask ", with: " asked ", options: .caseInsensitive)
            statement = statement.replacingOccurrences(of: " request ", with: " requested ", options: .caseInsensitive)
            statement = statement.replacingOccurrences(of: " attempt ", with: " attempted ", options: .caseInsensitive)
            statement = statement.replacingOccurrences(of: " refuse ", with: " refused ", options: .caseInsensitive)
            statement = statement.replacingOccurrences(of: " provide ", with: " provided ", options: .caseInsensitive)
            statement = statement.replacingOccurrences(of: " stop ", with: " stopped ", options: .caseInsensitive)
            statement = statement.replacingOccurrences(of: " seize ", with: " seized ", options: .caseInsensitive)
            statement = statement.replacingOccurrences(of: " send ", with: " sent ", options: .caseInsensitive)
            statement = statement.replacingOccurrences(of: " show ", with: " showed ", options: .caseInsensitive)
            statement = statement.replacingOccurrences(of: " protect ", with: " protected ", options: .caseInsensitive)
            
        } else if choice == "no" {
            statement = statement.replacingOccurrences(of: "Did the ", with: "The ")
            statement = statement.replacingOccurrences(of: "Did ", with: "")
            statement = statement.replacingOccurrences(of: "Did your ", with: "My ")
            statement = statement.replacingOccurrences(of: "Were you ", with: "I was not ")
            statement = statement.replacingOccurrences(of: "Was the ", with: "The ")
            statement = statement.replacingOccurrences(of: "Was your ", with: "My ")
            statement = statement.replacingOccurrences(of: "Does the ", with: "The ")
            
            // Add negation
            let verbs = ["ask", "request", "attempt", "refuse", "provide", "stop", "seize", "delete", "pressure", "send", "show", "protect"]
            for verb in verbs {
                if statement.lowercased().contains(" \(verb) ") {
                    statement = statement.replacingOccurrences(of: " \(verb) ", with: " did not \(verb) ", options: .caseInsensitive)
                    break
                }
            }
        } else {
            return "\(question): \(answer)"
        }
        
        // Capitalize first letter
        return statement.prefix(1).uppercased() + statement.dropFirst()
    }
}

#Preview {
    ScenarioPlayerView(category: "Civil rights", name: "stopped_by_police")
        .modelContainer(for: [ScenarioReport.self, StepReport.self, EvidenceItem.self])
}
