//  ScenarioPlayerView.swift
//  LegalBestie

import SwiftUI
import SwiftData

private let brandRose = Color(red: 0.965, green: 0.29, blue: 0.54)

struct ScenarioPlayerView: View {
    let category: String
    let name: String
    
    @Environment(\.modelContext) private var modelContext
    
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
            ZStack {
                LinearGradient(
                    colors: [brandRose.opacity(0.10), Color(.systemBackground)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                Group {
                    if let template = viewModel.template,
                       let node = viewModel.currentNode {
                        
                        VStack(alignment: .leading, spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(template.scenarioTitle)
                                    .font(.title.weight(.semibold))
                            }
                            
                            //progress indicator
                            if !viewModel.userResponses.isEmpty {
                                Text("\(viewModel.userResponses.count) questions answered")
                                    .font(.caption.weight(.medium))
                                    .foregroundStyle(brandRose)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 10)
                                    .background(
                                        Capsule().fill(brandRose.opacity(0.12))
                                    )
                            }
                            
                            
                            if !node.choices.isEmpty {
                                // question + choices UI
                                Text(node.question)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                    .padding(16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .fill(brandRose.opacity(0.14))
                                    )
                                
                                ForEach(node.choices, id: \.self) { choice in
                                    Button {
                                        viewModel.selectChoice(
                                            question: node.question,
                                            answer: choice.label,
                                            nextNode: choice.nextNode
                                        )
                                    } label: {
                                        Text(choice.label)
                                            .font(.headline)
                                            .foregroundStyle(.primary)
                                            .frame(maxWidth: .infinity, alignment: .center)
                                            .padding(.vertical, 18)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                    .fill(Color.white)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                    .stroke(brandRose.opacity(0.25), lineWidth: 1)
                                            )
                                    }
                                    .buttonStyle(.plain)
                                }
                                
                            } else {
                                
                                // Outcome reached UI
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Scenario Complete")
                                        .font(.title3.weight(.semibold))

                                    Text(node.question)
                                        .font(.body)
                                        .foregroundStyle(.secondary)

                                    Button {
                                        viewModel.generateReport()
                                        viewModel.saveReport(to: modelContext)
                                    } label: {
                                        Label("View Summary & Generate Report", systemImage: "doc.text")
                                            .frame(maxWidth: .infinity)
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(brandRose)
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(Color(.secondarySystemBackground))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(brandRose.opacity(0.18), lineWidth: 1)
                                )
                                .padding(.top, 4)
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
                            report: report,
                            scenarioCategory: category
                        )
                    } else {
                        Text("No scenario data")
                    }
                }
            }
        }
    }
}
