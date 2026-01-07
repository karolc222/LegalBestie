//  SavedReportsView.swift
//  LegalBestie
//
//  Created by Carolina LC on 18/11/2025.


import SwiftUI
import SwiftData

private let brandRose = Color(red: 0.965, green: 0.29, blue: 0.54)


struct SavedReportsView: View {
    @EnvironmentObject var auth: AuthService
    
    @Query private var allReports: [UserSavedReport]
    
    // Filter reports for current user
    private var userReports: [UserSavedReport] {
        guard let userId = auth.user?.id else { return [] }

        return allReports
            .filter { $0.userId == userId }
            .sorted { $0.savedAt > $1.savedAt }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [brandRose.opacity(0.10), Color(.systemBackground)],
                    startPoint: .top,
                    endPoint: .bottom
                )

                if userReports.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 48))
                            .foregroundStyle(brandRose.opacity(0.6))

                        Text("No saved reports yet")
                            .font(.title3.weight(.semibold))

                        Text("Complete scenarios and save reports to see them here.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(25)
                } else {
                    List {
                        ForEach(userReports, id: \.id) { report in
                            NavigationLink {
                                ReportDetailView(report: report)
                            } label: {
                                reportRow(report)
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Saved Reports")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private extension SavedReportsView {
    @ViewBuilder
    func reportRow(_ report: UserSavedReport) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(report.reportTitle)
                .font(.headline)

            Text(report.savedAt.formatted(date: .abbreviated, time: .omitted))
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(report.outcome)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            
            HStack {
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(brandRose.opacity(0.18), lineWidth: 1)
        )
    }
}
