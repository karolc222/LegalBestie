//  ScenarioOutcomeView.swift

import SwiftUI
import SwiftData
import UIKit

private let brandRose = Color(red: 0.965, green: 0.29, blue: 0.54)

struct ScenarioOutcomeView: View {
    let scenarioTitle: String
    let scenarioDescription: String
    let legalSummary: String?
    let topics: [String]
    let scenarioSources: [ScenarioSourceDTO]

    @State private var report: ScenarioReport?

    @EnvironmentObject var auth: AuthService
    @Environment(\.modelContext) private var modelContext

    private let scenarioService = ScenarioService()

    @State private var showSaveConfirmation = false
    @State private var hasBeenSaved = false
    @State private var exportedURL: URL?
    @State private var isShowingShareSheet = false

    private var effectiveUserLabel: String {
        if let email = auth.user?.email, !email.isEmpty {
            return email
        }
        if let uid = auth.user?.id, !uid.isEmpty {
            return uid
        }
        return "User"
    }

    private var fullReportText: String {
        """
        \(scenarioTitle)

        \(scenarioDescription)

        LEGAL SUMMARY
        \(legalSummary ?? "N/A")

        LEGAL SOURCES
        \(scenarioSources.map { "• \($0.sourceTitle)" }.joined(separator: "\n"))

        INCIDENT SUMMARY
        \((report?.steps ?? []).map { "• \($0.statement)" }.joined(separator: "\n"))
        """
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

                    if let report = report, !report.steps.isEmpty {
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
                            let safeName = scenarioTitle
                                .replacingOccurrences(of: "/", with: "-")
                                .replacingOccurrences(of: ":", with: "-")

                            let fileURL = FileManager.default.temporaryDirectory
                                .appendingPathComponent("\(safeName).txt")

                            do {
                                try fullReportText.write(to: fileURL, atomically: true, encoding: .utf8)
                                exportedURL = fileURL
                                isShowingShareSheet = true
                            } catch {
                                // If writing fails, do nothing (you can add an alert later if needed)
                                print("Export failed:", error.localizedDescription)
                            }
                        } label: {
                            Label("Download report", systemImage: "arrow.down.doc")
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
        .onAppear {
            guard report == nil else { return }

            let userId = auth.user?.email ?? "local-user"

            let newReport = scenarioService.startScenario(
                scenarioId: scenarioTitle,
                scenarioTitle: scenarioTitle,
                userId: userId
            )
            scenarioService.completeScenario(
                report: newReport,
                legalSummary: legalSummary ?? "",
                legalSources: scenarioSources
            )

            report = newReport
        }
        .navigationTitle("Outcome")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingShareSheet) {
            if let url = exportedURL {
                ShareSheet(url: url)
            }
        }
    }

    private func saveReportToProfile() {
        guard let userId = auth.user?.email,
              let report = report else { return }

        let savedReport = UserSavedReport(
            id: UUID().uuidString,
            userId: userId,
            reportTitle: scenarioTitle,
            scenarioCategory: scenarioTitle,
            outcome: fullReportText,
            sources: scenarioSources.map { $0.sourceTitle },
            savedAt: Date()
        )

        modelContext.insert(savedReport)
        try? modelContext.save()

        hasBeenSaved = true
        showSaveConfirmation = true
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
