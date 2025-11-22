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
    
    @StateObject private var legalSourceViewModel = LegalSourceViewModel()
    
    @State private var exportedURL: URL?
    @State private var isShowingShareSheet = false
    @State private var showReportPreview = false
    
    // Filtered sources based on topics
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
                
                // User's answers section
                if !report.steps.isEmpty {
                    Divider()
                    Text("Your Answers")
                        .font(.headline)
                    
                    ForEach(Array(report.steps.enumerated()), id: \.element.stepId) { index, step in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("\(index + 1).")
                                    .foregroundStyle(.secondary)
                                Text(step.question)
                                    .font(.subheadline)
                            }
                            
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                                    .font(.caption)
                                Text(step.userAnswer)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.leading, 20)
                            
                            Text(step.statement)
                                .font(.caption)
                                .italic()
                                .foregroundStyle(.blue)
                                .padding(.leading, 20)
                        }
                        .padding(.vertical, 4)
                        
                        if index < report.steps.count - 1 {
                            Divider()
                        }
                    }
                }
                
                if let summary = legalSummary {
                    Divider()
                    Text("Legal Summary")
                        .font(.headline)
                    
                    Text(summary)
                        .font(.body)
                }
                
                // Scenario-specific legal sources
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
                
                // Action buttons
                VStack(spacing: 12) {
                    Button {
                        showReportPreview = true
                    } label: {
                        Label("Preview Full Report", systemImage: "doc.text.magnifyingglass")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    
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
        .sheet(isPresented: $showReportPreview) {
            ReportPreviewView(report: report)
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

// Report Preview View
struct ReportPreviewView: View {
    let report: ScenarioReport
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("INCIDENT REPORT")
                            .font(.title.bold())
                        
                        Text("Scenario: \(report.scenarioTitle)")
                            .font(.headline)
                        
                        if let date = report.createdAt {
                            Text("Generated: \(formatDate(date))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Text("User: \(report.userName)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Incident Summary
                    VStack(alignment: .leading, spacing: 12) {
                        Text("INCIDENT SUMMARY")
                            .font(.headline)
                            .foregroundStyle(.blue)
                        
                        ForEach(report.steps, id: \.stepId) { step in
                            HStack(alignment: .top, spacing: 8) {
                                Text("•")
                                    .font(.body)
                                Text(step.statement)
                                    .font(.body)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Detailed Account
                    VStack(alignment: .leading, spacing: 12) {
                        Text("DETAILED ACCOUNT")
                            .font(.headline)
                            .foregroundStyle(.blue)
                        
                        ForEach(Array(report.steps.enumerated()), id: \.element.stepId) { index, step in
                            VStack(alignment: .leading, spacing: 6) {
                                
                                Text(\(step.statement)")
                                    .font(.caption)
                                    .foregroundStyle(.blue)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Legal Summary
                    VStack(alignment: .leading, spacing: 12) {
                        Text("RELEVANT LEGAL INFORMATION")
                            .font(.headline)
                            .foregroundStyle(.blue)
                        
                        Text(report.legalSummary)
                            .font(.body)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Legal Sources
                    if !report.legalSources.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("LEGAL REFERENCES")
                                .font(.headline)
                                .foregroundStyle(.blue)
                            
                            ForEach(report.legalSources, id: \.sourceId) { source in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("• \(source.sourceTitle)")
                                        .font(.subheadline.bold())
                                    
                                    Text("  Organization: \(source.sourceOrganization)")
                                        .font(.caption)
                                    
                                    Text("  Link: \(source.sourceUrl)")
                                        .font(.caption)
                                        .foregroundStyle(.blue)
                                    
                                    Text("  \(source.sourceDescription)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("Report Preview")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "en_GB")
        return formatter.string(from: date)
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
