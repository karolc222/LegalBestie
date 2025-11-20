import SwiftUI

struct ScenarioOutcomeView: View {
    // from ScenarioPlayerView
    let scenarioTitle: String
    let scenarioDescription: String
    let legalSummary: String?
    let topics: [String]
    let scenarioSources: [ScenarioSourceDTO]
    let report: ScenarioReport
    
    
    @StateObject private var legalSourceViewModel = LegalSourceViewModel()
    
    @State private var exportedURL: URL?
    @State private var isShowingShareSheet = false
    
    
    // Computed property: calculates a value every time it is processed
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
                
                Divider()
                
                Button {
                    Task {
                        do {
                            // Convert to exportable format
                            let exportable = ExportableReport(from: report)
                            
                            // Create filename
                            let filename = report.scenarioTitle
                                .replacingOccurrences(of: " ", with: "_")
                            + "_report.pdf"
                            
                            // Temporary file location
                            let tmpURL = FileManager.default
                                .temporaryDirectory
                                .appendingPathComponent(filename)
                            
                            // Generate PDF
                            try ReportGeneratorService.generatePDF(from: exportable, to: tmpURL)
                            
                            // Store URL for share sheet
                            exportedURL = tmpURL
                            isShowingShareSheet = true
                            
                            print("✅ Report exported to: \(tmpURL.path)")
                        } catch {
                            print("❌ Report export failed: ", error.localizedDescription)
                        }
                    }
                } label: {
                    Label("Download Report (PDF)", systemImage: "arrow.down.doc")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        
        .navigationTitle("Outcome")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            print("ScenarioOutcomeView topics:", topics)
            print("Loaded sources in VM:", legalSourceViewModel.sources.count)
            print("All source topics:", legalSourceViewModel.sources.map(\.sourceTopics))
        }
        
        .sheet(isPresented: $isShowingShareSheet) {
            if let url = exportedURL {
                ShareLink(item: url)
            }
        }
    }
    
}
