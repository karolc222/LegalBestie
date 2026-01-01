//  SavedReportsView.swift
//  LegalBestie
//
//  Created by Carolina LC on 18/11/2025.

import SwiftUI
import SwiftData

private let brandRose = Color(red: 0.965, green: 0.29, blue: 0.54)

struct SavedReportsView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var auth: AuthService
    
    @Query private var allReports: [ScenarioReport]

    // Filter reports for current user
    private var userReports: [ScenarioReport] {
        guard let user = auth.user else { return [] }

        let label: String
        if let email = user.email, !email.isEmpty {
            label = email
        } else {
            label = user.id
        }

        return allReports
            .filter { $0.userName == label }
            .sorted {
                let d0 = $0.createdAt ?? .distantPast
                let d1 = $1.createdAt ?? .distantPast
                return d0 > d1
            }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [brandRose.opacity(0.10), Color(.systemBackground)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                Group {
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
                        .padding(24)
                    } else {
                        List {
                            ForEach(userReports, id: \.scenarioId) { report in
                                NavigationLink {
                                    ReportDetailView(report: report)
                                } label: {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(report.scenarioTitle)
                                            .font(.headline)

                                        Text((report.createdAt ?? .now).formatted(date: .abbreviated, time: .omitted))
                                            .font(.caption)
                                            .foregroundStyle(.secondary)

                                        HStack(spacing: 12) {
                                            Text("\(report.steps.count) steps")
                                            if !report.legalSources.isEmpty {
                                                Text("\(report.legalSources.count) sources")
                                            }
                                        }
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
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
                                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                                .listRowBackground(Color.clear)
                            }
                            .onDelete(perform: deleteReports)
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

    private func deleteReports(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(userReports[index])
        }
        try? modelContext.save()
    }
}

