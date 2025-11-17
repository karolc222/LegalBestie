import SwiftUI

struct ScenarioOutcomeView: View {
    let scenarioTitle: String
    let scenarioDescription: String
    let legalSummary: String?
    let topics: [String]
    let scenarioSources: [ScenarioSourceDTO]
    
    @StateObject private var legalSourceViewModel = LegalSourceViewModel()
    
    // Computed property for filtered sources
    private var filteredSources: [LegalSource] {
        legalSourceViewModel.sources.filter { src in
            !Set(src.sourceTopics).isDisjoint(with: topics)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                Text(scenarioTitle)
                    .font(.title2.bold())
                
                Text(scenarioDescription)
                    .font(.body)
                
                if let summary = legalSummary {
                    Divider()
                    Text("Legal Summary")
                        .font(.headline)
                    
                    Text(summary)
                        .font(.body)
                }
                
                // Scenario-specific legal sources FIRST
                if !scenarioSources.isEmpty {
                    Divider()
                    Text("Legal Sources for This Scenario")
                        .font(.headline)
                    
                    ForEach(scenarioSources) { source in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(source.sourceTitle)
                                .font(.subheadline.bold())
                            
                            Text(source.sourceDescription)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            HStack {
                                Text(source.sourceOrganization)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                Text("• \(source.sourceStatus)")
                                    .font(.caption2)
                                    .foregroundStyle(.green)
                            }
                            
                            Link("Open Source", destination: source.sourceLink)
                                .font(.caption)
                                .buttonStyle(.bordered)
                        }
                        .padding()
                        .background(.thinMaterial)
                        .cornerRadius(12)
                    }
                }
                
                // Additional filtered sources
                if !filteredSources.isEmpty {
                    Divider()
                    Text("Additional Related Sources")
                        .font(.headline)
                    
                    ForEach(filteredSources) { src in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(src.sourceTitle)
                                .font(.subheadline.bold())
                            
                            Text(src.sourceDescription)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            if let url = src.urlValue {
                                Link("Open Source", destination: url)
                                    .font(.caption)
                                    .buttonStyle(.bordered)
                            }
                            
                            HStack {
                                if !src.sourceOrganization.isEmpty {
                                    Text(src.sourceOrganization)
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                                
                                if !src.sourceStatus.isEmpty {
                                    Text("• \(src.sourceStatus)")
                                        .font(.caption2)
                                        .foregroundStyle(.green)
                                }
                            }
                        }
                        .padding()
                        .background(.thinMaterial)
                        .cornerRadius(12)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Outcome")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            print("ScenarioOutcomeView topics:", topics)
            print("Loaded sources in VM:", legalSourceViewModel.sources.count)
            print("All source topics:", legalSourceViewModel.sources.map(\.sourceTopics))
        }
    }
}
