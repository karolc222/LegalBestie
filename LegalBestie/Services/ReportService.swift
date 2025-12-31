//  ReportService.swift
//  LegalBestie
//
//  Created by Carolina LC on 31/12/2025.

import Foundation
import FirebaseFirestoreInternal
import FirebaseAuth

@MainActor
class ReportService: ObservableObject {
    private let database = Firestore.firestore()
    
    @Published var savedReport: [UserSavedReport] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    func saveReport(
        scenarioTitle: String,
        scenarioCategory: String,
        scenarioOutcome: String,
        sources: [String],
    ) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "ReportService", code: 401,
                          userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        let report = UserSavedReport(
            id: String,
            userId: userId,
            scenarioTitle: scenarioTitle,
            scenarioCategory: scenarioCategory,
            scenarioOutcome: String,
            scenarioSources: [String],
            savedAt: Date()
        )
        
        isLoading = true
        defer { isLoading = false }
        
        do {
                    try database.collection("savedReports").addDocument(from: report)
                } catch {
                    errorMessage = "Failed to save report: \(error.localizedDescription)"
                    throw error
                }
            }
            
            // MARK: - Fetch User's Reports
            
            func fetchReports() async throws {
                guard let userId = Auth.auth().currentUser?.uid else {
                    throw NSError(domain: "ReportService", code: 401,
                                 userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
                }
                
                isLoading = true
                defer { isLoading = false }
                
                do {
                    let snapshot = try await database.collection("savedReports")
                        .whereField("userId", isEqualTo: userId)
                        .order(by: "timestamp", descending: true)
                        .getDocuments()
                    
                    UserSavedReports = snapshot.documents.compactMap { doc in
                        try? doc.data(as: SavedReport.self)
                    }
                } catch {
                    errorMessage = "Failed to fetch reports: \(error.localizedDescription)"
                    throw error
                }
            }
            
            // MARK: - Delete Report
            
            func deleteReport(_ report: UserSavedReport) async throws {
                guard let reportId = report.id else { return }
                
                isLoading = true
                defer { isLoading = false }
                
                do {
                    try await db.collection("savedReports").document(reportId).delete()
                    savedReports.removeAll { $0.id == reportId }
                } catch {
                    errorMessage = "Failed to delete report: \(error.localizedDescription)"
                    throw error
                }
            }
        }
