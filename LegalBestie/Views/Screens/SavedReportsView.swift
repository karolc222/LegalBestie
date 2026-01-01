//  SavedReportsView.swift
//  LegalBestie
//
//  Created by Carolina LC on 18/11/2025.

import Foundation
import SwiftUI
import SwiftData

struct SavedReportsView: View {
    @Environment(\.modelContext) private var modelContext  
    @EnvironmentObject var auth: AuthService
    
    @Query private var allReports: [UserSavedReport]

    // Filter reports for current user
    private var userReports: [UserSavedReport] {
        guard let userId = auth.user?.id else { return [] }
        return allReports.filter { $0.userid == userId }
            .sorted { $0.savedAt > $1.savedAt }
    }

    var body: some View {
        NavigationView {
            Group {
                if userReports.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        Text("No saved reports yet")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        Text("Complete scenarios and save reports to see them here")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(userReports) { report in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(report.reportTitle)
                                    .font(.headline)
                                
                                Text(report.scenarioCategory)
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                
                                Text(report.formattedDate)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                if !report.sources.isEmpty {
                                    Text("\(report.sources.count) sources")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: deleteReports)
                    }
                }
            }
            .navigationTitle("Saved Reports")
            .toolbar {
                if !userReports.isEmpty {
                    EditButton()
                }
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
