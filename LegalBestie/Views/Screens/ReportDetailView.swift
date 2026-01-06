//  ReportDetailView.swift
//  LegalBestie
//
//  Created by Carolina LC on 01/01/2026.

import SwiftUI
import SwiftData

private let brandRose = Color(red: 0.965, green: 0.29, blue: 0.54)

struct ReportDetailView: View {
    let report: UserSavedReport

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

                    Text(report.reportTitle)
                        .font(.title.weight(.semibold))
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.white)
                        )

                    Text(report.outcome)
                        .font(.body)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.white)
                        )

                    Button {
                        let fileURL = FileManager.default.temporaryDirectory
                            .appendingPathComponent("\(report.reportTitle).txt")

                        try? report.outcome.write(
                            to: fileURL,
                            atomically: true,
                            encoding: .utf8
                        )

                        let activityVC = UIActivityViewController(
                            activityItems: [fileURL],
                            applicationActivities: nil
                        )

                        UIApplication.shared
                            .connectedScenes
                            .compactMap { $0 as? UIWindowScene }
                            .first?
                            .keyWindow?
                            .rootViewController?
                            .present(activityVC, animated: true)

                    } label: {
                        Label("Download to device", systemImage: "arrow.down.doc")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(brandRose)
                }
            }
            .padding()
        }
        .navigationTitle("Report")
        .navigationBarTitleDisplayMode(.inline)
    }
}
