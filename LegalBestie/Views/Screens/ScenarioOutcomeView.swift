//  ScenarioOutcomeView.swift
//  LegalBestie

//  With report preview before download

import SwiftUI

struct ScenarioOutcomeView: View {
    let scenarioTitle: String
    let scenarioDescription: String
    let legalSummary: String?
    let topics: [String]
    let scenarioSources: [ScenarioSourceDTO]
    let report: ScenarioReport
    
    @State private var exportedURL: URL?
    @State private var isShowingShareSheet = false
    
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

                if !scenarioSources.isEmpty {
                    Divider()
                    Text("Legal Sources")
                        .font(.headline)
                    ForEach(scenarioSources) { source in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(source.sourceTitle).bold()
                            Link("Open Source", destination: source.sourceLink)
                        }
                        .padding(.vertical, 4)
                    }
                }

                if !report.steps.isEmpty {
                    Divider()
                    Text("Your Incident Summary")
                        .font(.headline)

                    ForEach(report.steps) { step in
                        Text("• \(step.statement)")
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }

                Divider()

                // Action buttons
                VStack(spacing: 12) {
                    Button {
                        Task {
                            await generateAndSharePDF()
                        }
                    } label: {
                        Label("Download Report (PDF)", systemImage: "arrow.down.doc")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
        }
        .navigationTitle("Outcome")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            print("ScenarioOutcomeView loaded")
            print("Topics:", topics)
            print("Steps:", report.steps.count)
        }
        .sheet(isPresented: $isShowingShareSheet) {
            if let url = exportedURL {
                ShareSheet(url: url)
            }
        }
    }
    
    private func generateAndSharePDF() async {
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
            await MainActor.run {
                exportedURL = tmpURL
                isShowingShareSheet = true
            }
            
            print(" Report exported to: \(tmpURL.path)")
        } catch {
            print(" Report export failed: ", error.localizedDescription)
        }
    }
}


// Share sheet wrapper
struct ShareSheet: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [url], applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
