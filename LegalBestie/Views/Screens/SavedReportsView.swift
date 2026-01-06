//  SavedReportsView.swift
//  LegalBestie
//
//  Created by Carolina LC on 18/11/2025.


import SwiftUI
import SwiftData

private let brandRose = Color(red: 0.965, green: 0.29, blue: 0.54)


struct SavedReportsView: View {
    @EnvironmentObject var auth: AuthService
    
    @Query(sort: \UserSavedReport.savedAt, order: .reverse)
    private var allReports: [UserSavedReport]
    
    private var userReports: [UserSavedReport] {
        allReports
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [brandRose.opacity(0.10), Color(.systemBackground)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                Group {
                    if userReports.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "doc.text")
                                .font(.system(size: 48))
                                .foregroundStyle(brandRose.opacity(0.6))
                            
                            Text("No saved reports yet")
                                .font(.title3.weight(.semibold))
                        }
                        .padding(25)
                        
                    } else {
                        List {
                            ForEach(userReports) { report in
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
            }
            .navigationTitle("Saved Reports")
            .navigationBarTitleDisplayMode(.inline)
        }
        
        .onAppear {
            print("📦 Total reports in SwiftData:", allReports.count)
            print("👤 Current auth email:", auth.user?.email ?? "nil")
            
            for report in allReports {
                print("🧾 Stored report.userId:", report.userId)
            }
        }
    }
    
    
    @ViewBuilder
    private func reportRow(_ report: UserSavedReport) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(report.reportTitle)
                .font(.headline)
                .lineLimit(2)

            Text(report.savedAt.formatted(date: .abbreviated, time: .omitted))
                .font(.caption)
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
    
}
