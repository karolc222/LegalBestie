//  ReportGeneratorService.swift
//  LegalBestie
//
//  Generic report export service (PDF)
//  Created by Carolina LC on 18/11/2025.

import Foundation
import UIKit

//Generic, reusable report structure that can represent: a scenario outcome, an incident log, a saved AI chat summary, a collection of legal articles

struct ExportableReport {
    
    //Logical section of text in the report (e.g. "Incident Summary", "User Responses")
    struct Section {
        let heading: String
        let body: String
    }
    
    struct Source {
        let title: String
        let url: String
        let description: String
        let organisation: String?
    }
    
    let title: String
    let createdAt: Date
    let ownerName: String?
    let summary: String?
    let sections: [Section]
    let sources: [Source]
}

final class ReportGeneratorService {
    
    //   Destination file URL
    static func generatePDF(
        from report: ExportableReport,
        to url: URL
    ) throws {
        
        // PDF metadata
        let pdfMetaData: [CFString: Any] = [
            kCGPDFContextCreator: "LegalBestie",
            kCGPDFContextAuthor: report.ownerName ?? "LegalBestie User",
            kCGPDFContextTitle: report.title
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        // A4 size
        let pageRect = CGRect(x: 0, y: 0, width: 595, height: 842)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { context in
            context.beginPage()
            
            let padding: CGFloat = 20
            var y: CGFloat = 40
            
            // Small helper to draw a block of text and move the cursor down
            func draw(_ text: String, size: CGFloat = 14, bold: Bool = false) {
                let font: UIFont = bold
                    ? .boldSystemFont(ofSize: size)
                    : .systemFont(ofSize: size)
                
                let attributes: [NSAttributedString.Key: Any] = [.font: font]
                
                let maxRect = CGRect(
                    x: padding,
                    y: y,
                    width: pageRect.width - 2 * padding,
                    height: .greatestFiniteMagnitude
                )
                
                let height = text.boundingRect(
                    with: maxRect.size,
                    options: .usesLineFragmentOrigin,
                    attributes: attributes,
                    context: nil
                ).height
                
                text.draw(
                    in: CGRect(
                        x: padding,
                        y: y,
                        width: maxRect.width,
                        height: height
                    ),
                    withAttributes: attributes
                )
                
                y += height + 10
            }
                        
            draw("Incident Report", size: 22, bold: true)
            draw("Title: \(report.title)", bold: true)
            
            let dateString = report.createdAt.formatted(date: .abbreviated, time: .shortened)
            draw("Generated: \(dateString)")
            
            if let owner = report.ownerName, !owner.isEmpty {
                draw("User: \(owner)")
            }
            
            // Spacer
            y += 10
            
            
            // Optional summary
            
            if let summary = report.summary, !summary.isEmpty {
                draw("Summary", size: 18, bold: true)
                draw(summary)
                y += 5
            }
            
            // Sections
            
            for section in report.sections {
                // Simple page break logic if we get too close to the bottom
                if y > pageRect.height - 100 {
                    context.beginPage()
                    y = 40
                }
                
                draw(section.heading, size: 18, bold: true)
                draw(section.body)
                y += 5
            }
            
            
            // Legal sources
            
            if !report.sources.isEmpty {
                if y > pageRect.height - 150 {
                    context.beginPage()
                    y = 40
                }
                
                draw("Legal Sources", size: 18, bold: true)
                
                for source in report.sources {
                    let titleLine = "• \(source.title)"
                    draw(titleLine, bold: true)
                    
                    if let org = source.organisation, !org.isEmpty {
                        draw("Organisation: \(org)", size: 12)
                    }
                    
                    draw("Link: \(source.url)", size: 12)
                    
                    if !source.description.isEmpty {
                        draw(source.description, size: 12)
                    }
                    
                    y += 5
                }
            }
        }
        
        // Write PDF bytes to disk
        try data.write(to: url)
    }
}

// Example adapter from ScenarioReport (optional)

/*
 This shows how a feature-specific model (ScenarioReport)
 can be converted into the generic ExportableReport used
 by the PDF generator.
 
 You can write similar adapters later for:
 - ChatQuery / ChatQueryNote
 - Incident models
 - Article collections
 */

extension ExportableReport {
    
    // Convenience initializer to build an ExportableReport from a ScenarioReport
    init(from scenarioReport: ScenarioReport) {
        
        // Section 1: Legal summary
        let summarySection = Section(
            heading: "Scenario Summary",
            body: scenarioReport.legalSummary
        )
        
        // Section 2: User responses (statements per step)
        let responsesBody = scenarioReport.steps
            .map { "• \($0.statement)" }   // assuming StepReport has `statement: String`
            .joined(separator: "\n")
        
        let responsesSection = Section(
            heading: "User Responses",
            body: responsesBody
        )
        
        // Legal sources mapped into ExportableReport.Source
        let sources = scenarioReport.legalSources.map {
            Source(
                title: $0.sourceTitle,
                url: $0.sourceUrl,
                description: $0.sourceDescription,
                organisation: $0.sourceOrganization
            )
        }
        
        self = ExportableReport(
            title: scenarioReport.scenarioTitle,
            createdAt: scenarioReport.createdAt ?? Date(),
            ownerName: scenarioReport.userName,
            summary: nil,                        // or a shorter one if you generate it
            sections: [summarySection, responsesSection],
            sources: sources
        )
    }
}
