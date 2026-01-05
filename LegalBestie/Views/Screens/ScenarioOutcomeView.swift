//  ScenarioOutcomeView.swift
//  LegalBestie

//  With report preview before download

import SwiftUI
import SwiftData

private let brandRose = Color(red: 0.965, green: 0.29, blue: 0.54) // #f64a8a-inspired

struct ScenarioOutcomeView: View {
    let scenarioTitle: String
    let scenarioDescription: String
    let legalSummary: String?
    let topics: [String]
    let scenarioSources: [ScenarioSourceDTO]
    let report: ScenarioReport
    
    @EnvironmentObject var auth: AuthService
    @Environment(\.modelContext) private var modelContext
    
    @State private var exportedURL: URL?
    @State private var isShowingShareSheet = false
    @State private var showSaveConfirmation = false
    @State private var hasBeenSaved = false
    
    private var effectiveUserLabel: String {
        if let email = auth.user?.email, !email.isEmpty {
            return email
        }
        if let uid = auth.user?.id, !uid.isEmpty {
            return uid
        }
        return "User"
    }

    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [brandRose.opacity(0.10), Color(.systemBackground)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(scenarioTitle)
                            .font(.title.weight(.semibold))

                        Text(scenarioDescription)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }

                    if let summary = legalSummary {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Legal Summary")
                                .font(.headline)

                            Text(summary)
                                .font(.body)
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.white)
                        )
                    }

                    if !scenarioSources.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Legal Sources")
                                .font(.headline)

                            ForEach(scenarioSources) { source in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(source.sourceTitle)
                                        .font(.subheadline.weight(.medium))

                                    Link("Open source", destination: source.sourceLink)
                                        .font(.caption)
                                        .foregroundStyle(brandRose)
                                }
                                .padding(.vertical, 6)
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.white)
                        )
                    }

                    if !report.steps.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Your Incident Summary")
                                .font(.headline)

                            ForEach(report.steps) { step in
                                Text("• \(step.statement)")
                                    .font(.body)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.white)
                        )
                    }

                    // Action buttons
                    VStack(spacing: 14) {
                        Button {
                            Task {
                                await generateAndSharePDF()
                            }
                        } label: {
                            Label("Download Report (PDF)", systemImage: "arrow.down.doc")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .tint(brandRose)
                        
                        Button {
                            saveReportToProfile()
                        } label: {
                            Label(
                                hasBeenSaved ? "Saved to Profile" : "Save to Profile",
                                systemImage: hasBeenSaved ? "checkmark.circle.fill" : "person.crop.circle.badge.plus"
                            )
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(brandRose)
                        .disabled(hasBeenSaved)
                        .alert("Saved", isPresented: $showSaveConfirmation) {
                            Button("OK", role: .cancel) {}
                        } message: {
                            Text("Report saved to your profile for easy access.")
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Outcome")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            print("ScenarioOutcomeView loaded")
            print("Topics:", topics)
            print("Steps:", report.steps.count)
            print("Auth user label:", effectiveUserLabel)
        }
        .sheet(isPresented: $isShowingShareSheet) {
            if let url = exportedURL {
                ShareSheet(url: url)
            }
        }
    }

    private func saveReportToProfile() {
        // Stamp report with user label (email/uid) for now.
        report.userId = effectiveUserLabel

        modelContext.insert(report)
        do {
            try modelContext.save()
            hasBeenSaved = true
            showSaveConfirmation = true
            print("Report saved to profile for:", effectiveUserLabel)
        } catch {
            print("Failed to save report:", error.localizedDescription)
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
