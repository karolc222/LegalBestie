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

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Incident Summary")
                            .font(.headline)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.white)
                    )
                }
                .padding()
            }
        }
        .navigationTitle("Report")
        .navigationBarTitleDisplayMode(.inline)
    }
}
