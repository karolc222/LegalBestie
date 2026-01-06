import SwiftUI
import SwiftData

private let brandRose = Color(red: 0.965, green: 0.29, blue: 0.54)

// Wrapper required for .sheet(item:)
struct ShareURL: Identifiable {
    let id = UUID()
    let url: URL
}

struct ReportDetailView: View {
    let report: UserSavedReport

    @State private var exportItem: ShareURL?

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [brandRose.opacity(0.10), Color(.systemBackground)],
                startPoint: .top,
                endPoint: .bottom
            )

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    Text(report.reportTitle)
                        .font(.title.bold())

                    Text(report.savedAt.formatted(date: .long, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    section(title: "Outcome") {
                        Text(report.outcome)
                    }

                    if let summary = report.legalSummary {
                        section(title: "Legal Summary") {
                            Text(summary)
                        }
                    }

                    if !report.incidentSteps.isEmpty {
                        section(title: "Incident Summary") {
                            ForEach(report.incidentSteps, id: \.self) { step in
                                Text("• \(step)")
                            }
                        }
                    }

                    if !report.sources.isEmpty {
                        section(title: "Legal Sources") {
                            ForEach(report.sources.indices, id: \.self) { i in
                                Text("• \(report.sources[i])")
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Report")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $exportItem) { item in
            ShareSheet(url: item.url)
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                exportReport()
            } label: {
                Label("Download Report", systemImage: "arrow.down.doc")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(brandRose)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal)
                    .padding(.bottom, 8)
            }
        }
    }

    @ViewBuilder
    private func section(title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title.uppercased())
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            content()
                .font(.body)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(brandRose.opacity(0.18), lineWidth: 1)
        )
    }

    private func exportReport() {
        let text = """
        \(report.reportTitle)

        Outcome:
        \(report.outcome)

        Legal Summary:
        \(report.legalSummary ?? "N/A")

        Incident Summary:
        \(report.incidentSteps.map { "• \($0)" }.joined(separator: "\n"))

        Sources:
        \(report.sources.joined(separator: "\n"))
        """

        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(report.reportTitle).txt")

        try? text.write(to: url, atomically: true, encoding: .utf8)
        exportItem = ShareURL(url: url)
    }
}
