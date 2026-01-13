struct ShareItem: Identifiable {
    let id = UUID()
    let url: URL
}
//  ScenarioOutcomeView.swift
//  LegalBestie

//  With report preview before download

import SwiftUI
import SwiftData

private let brandRose = Color(red: 0.965, green: 0.29, blue: 0.54)

struct ScenarioOutcomeView: View {
    let scenarioTitle: String
    let scenarioDescription: String
    let legalSummary: String?
    let topics: [String]
    let scenarioSources: [ScenarioSourceDTO]
    let report: ScenarioReport
    let scenarioCategory: String
    
    @EnvironmentObject var auth: AuthService
    @Environment(\.modelContext) private var modelContext
    
    @State private var shareItem: ShareItem?
    @State private var showSaveConfirmation = false
    @State private var hasBeenSaved = false

    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [brandRose.opacity(0.10), Color(.systemBackground)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    Text(scenarioTitle)
                        .font(.title.weight(.semibold))

                    Text(scenarioDescription)
                        .foregroundStyle(.secondary)

                    if let summary = legalSummary {
                        section(title: "Legal Summary") {
                            Text(summary)
                        }
                    }

                    if !scenarioSources.isEmpty {
                        section(title: "Legal Sources") {
                            ForEach(scenarioSources) { source in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(source.sourceTitle)
                                        .font(.subheadline.weight(.medium))
                                    Link("Open source", destination: source.sourceLink)
                                        .font(.caption)
                                        .foregroundStyle(brandRose)
                                }
                            }
                        }
                    }

                    if !report.steps.isEmpty {
                        section(title: "Your Incident Summary") {
                            ForEach(report.steps) { step in
                                Text("• \(step.statement)")
                            }
                        }
                    }

                    VStack(spacing: 12) {
                        Button {
                            Task { await generateAndSharePDF() }
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
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Outcome")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $shareItem) { item in
            ShareSheet(url: item.url)
        }
        .alert("Saved to Profile", isPresented: $showSaveConfirmation) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your report has been successfully saved and is available in your Saved Library.")
        }
    }

    private func saveReportToProfile() {
        guard let userId = auth.user?.id else { return }

        let savedReport = UserSavedReport(
            userId: userId,
            reportTitle: scenarioTitle,
            scenarioCategory: scenarioCategory,
            outcome: scenarioDescription,
            legalSummary: legalSummary,
            incidentSteps: report.steps.map { $0.statement },
            sources: scenarioSources.map { $0.sourceTitle },
            savedAt: Date()
        )

        modelContext.insert(savedReport)

        do {
            try modelContext.save()
            hasBeenSaved = true
            showSaveConfirmation = true
        } catch {
            print("Failed to save report:", error.localizedDescription)
        }
    }

    private func generateAndSharePDF() async {
        do {
            let exportable = ExportableReport(from: report)
            let filename = report.scenarioTitle.replacingOccurrences(of: " ", with: "_") + "_report.pdf"
            let tmpURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
            try ReportGeneratorService.generatePDF(from: exportable, to: tmpURL)
            await MainActor.run {
                shareItem = ShareItem(url: tmpURL)
            }
        } catch {
            print(" Report export failed: ", error.localizedDescription)
        }
    }
}

@ViewBuilder
func section(title: String, @ViewBuilder content: () -> some View) -> some View {
    VStack(alignment: .leading, spacing: 12) {
        Text(title)
            .font(.headline)

        content()
    }
    .padding(16)
    .background(
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.white)
    )
}
