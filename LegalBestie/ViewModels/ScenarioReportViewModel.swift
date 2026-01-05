//  ScenarioReportViewModel.swift
//  LegalBestie
//
//  Created by Carolina LC on 02/11/2025.


import Foundation
import SwiftData
import SwiftUI

@MainActor
final class ScenarioReportViewModel: ObservableObject {
    
    @Published var reports: [ScenarioReport] = []
    @Published var isExporting = false
    @Published var exportError: String?
    @Published var showExportSuccess = false
    
    // Dependencies
    private let modelContext: ModelContext
    private let authService: AuthService
    
    init(modelContext: ModelContext, authService: AuthService) {
        self.modelContext = modelContext
        self.authService = authService
    }
    
    // Report Management

    func loadUserReports() {
        reports = []
    }
    
    func saveReport(_ report: ScenarioReport) throws {
        guard let userId = authService.user?.email else {
            throw AppError.signInRequired
        }

        let savedReport = UserSavedReport(
            id: UUID().uuidString,
            userId: userId,
            reportTitle: report.scenarioTitle,
            scenarioCategory: report.scenarioId,
            outcome: report.legalSummary,
            sources: report.legalSources.map { $0.sourceTitle },
            savedAt: Date()
        )

        modelContext.insert(savedReport)
        try modelContext.save()
    }
    
    func deleteReport(_ report: ScenarioReport) throws {
        modelContext.delete(report)
        try modelContext.save()
        
        loadUserReports() // Refresh list
    }
    
    
    // Export report
    
    func exportToPDF(report: ScenarioReport) async -> URL? {
        isExporting = true
        exportError = nil
        
        defer { isExporting = false }
        
        do {
            let exportable = ExportableReport(from: report)
            
            let filename = report.scenarioTitle
                .replacingOccurrences(of: " ", with: "_")
                .appending("_report.pdf")
            
            let tmpURL = FileManager.default
                .temporaryDirectory
                .appendingPathComponent(filename)
            
            try ReportGeneratorService.generatePDF(from: exportable, to: tmpURL)
            
            showExportSuccess = true
            return tmpURL
            
        } catch {
            exportError = "Failed to export: \(error.localizedDescription)"
            return nil
        }
    }
    
    
    private var effectiveUserId: String? {
        authService.user?.email
    }
    
    enum AppError: Error, LocalizedError {
        case signInRequired
        case exportFailed
        case unknown

        var errorDescription: String? {
            switch self {
            case .signInRequired:
                return "You must be signed in to perform this action."
            case .exportFailed:
                return "An error occurred while exporting the report."
            case .unknown:
                return "An unknown error occurred."
            }
        }
    }
}
