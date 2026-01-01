//  ReportDetailView.swift
//  LegalBestie
//
//  Created by Carolina LC on 01/01/2026.

import SwiftUI

private let brandRose = Color(red: 0.965, green: 0.29, blue: 0.54) 

struct ReportDetailView: View {
    let report: ScenarioReport

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
                Text(report.scenarioTitle)
                    .font(.title.weight(.semibold))

                Text((report.createdAt ?? .now).formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if !report.legalSummary.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Legal Summary")
                            .font(.headline)

                        Text(report.legalSummary)
                            .font(.body)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.white)
                    )
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Your Incident Summary")
                        .font(.headline)

                    if report.steps.isEmpty {
                        Text("No steps recorded.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(report.steps) { step in
                            Text("• \(step.statement)")
                                .font(.body)
                        }
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.white)
                )
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Legal Sources")
                        .font(.headline)

                    if report.legalSources.isEmpty {
                        Text("No sources were saved with this report.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(report.legalSources) { source in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(source.sourceTitle)
                                    .font(.subheadline.weight(.medium))

                                if let url = URL(string: source.sourceUrl) {
                                    Link("Open source", destination: url)
                                        .font(.caption)
                                        .foregroundStyle(brandRose)
                                }

                                if !source.sourceDescription.isEmpty {
                                    Text(source.sourceDescription)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 6)
                        }
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.white)
                )
            }
            .padding()
        }
        .navigationTitle("Report")
        .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
