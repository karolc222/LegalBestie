//  ScenarioPlayerView.swift
//  LegalBestie

import SwiftUI
import SwiftData

struct ScenarioPlayerView: View {
    let category: String
    let name: String
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var auth: AuthService
    
    @StateObject private var viewModel: ScenarioPlayerViewModel
    
    init(category: String, name: String) {
        self.category = category
        self.name = name
        _viewModel = StateObject(wrappedValue: ScenarioPlayerViewModel(
            category: category,
            name: name
        ))
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if let template = viewModel.template,
                   let node = viewModel.currentNode {
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text(template.scenarioTitle)
                            .font(.title2.bold())
                        
                        // Progress indicator
                        if !viewModel.userResponses.isEmpty {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                                Text("\(viewModel.userResponses.count) questions answered")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                        
                        
                        if !node.choices.isEmpty {
                            // Question + choices UI
                            Text(node.question)
                                .font(.headline)
                                .padding(.vertical, 8)
                            
                            ForEach(node.choices, id: \.self) { choice in
                                Button(choice.label) {
                                    viewModel.selectChoice(
                                        question: node.question,
                                        answer: choice.label,
                                        nextNode: choice.nextNode
                                    )
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
                                    viewModel.generateReport()
                                    viewModel.saveReport(to: modelContext)
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
                    
                } else if let errorText = viewModel.errorText {
                    VStack(spacing: 12) {
                        Text("Failed to load scenario").font(.headline)
                        Text(errorText).font(.caption).foregroundStyle(.secondary)
                        Button("Retry") {
                            Task { await viewModel.loadScenario() }
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                } else {
                    ProgressView()
                }
            }
            .task {
                await viewModel.loadScenario()
            }
            .navigationTitle("Scenario")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $viewModel.showOutcome) {
                if let template = viewModel.template,
                   let report = viewModel.report {
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
}
