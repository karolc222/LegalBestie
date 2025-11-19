//  ReportGeneratorService.swift
//  LegalBestie
//
//  Created by Carolina LC on 18/11/2025.

import Foundation

class ReportGeneratorService {
    static func makeReport (
        session: ScenarioSession,
        template: ScenarioTemplate,
        allSources: [LegalSource]
        ) -> ScenarioReport {
        
            
    }
    )
    
    
}

static func exportToWord(
        session: ScenarioSession,
        template: ScenarioTemplate,
        outputPath: String = "/mnt/user-data/outputs/report.docx"
    ) async throws -> URL {
