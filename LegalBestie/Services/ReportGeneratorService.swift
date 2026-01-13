//  ReportGeneratorService.swift
//  LegalBestie
//
//  Created by Carolina LC on 18/11/2025.import Foundation

import UIKit

struct ExportableReport {

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

    static func generatePDF(from report: ExportableReport, to url: URL) throws {

        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = [
            kCGPDFContextCreator: "LegalBestie",
            kCGPDFContextAuthor: report.ownerName ?? "LegalBestie User",
            kCGPDFContextTitle: report.title
        ] as [String: Any]

        
        let page = CGRect(x: 0, y: 0, width: 595, height: 842)
        let renderer = UIGraphicsPDFRenderer(bounds: page, format: format)

        let data = renderer.pdfData { context in
            var cursor: CGFloat = 40
            context.beginPage()

            func draw(_ text: String, size: CGFloat = 14, bold: Bool = false) {
                let font = bold
                    ? UIFont.boldSystemFont(ofSize: size)
                    : UIFont.systemFont(ofSize: size)

                let attrs: [NSAttributedString.Key: Any] = [.font: font]
                let maxWidth = page.width - 40

                let rect = text.boundingRect(
                    with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude),
                    options: .usesLineFragmentOrigin,
                    attributes: attrs,
                    context: nil
                )

                if cursor + rect.height > page.height - 40 {
                    context.beginPage()
                    cursor = 40
                }

                text.draw(
                    in: CGRect(x: 20, y: cursor, width: maxWidth, height: rect.height),
                    withAttributes: attrs
                )

                cursor += rect.height + 10
            }

            
            draw("Incident Report", size: 22, bold: true)
            draw("Title: \(report.title)", bold: true)
            draw("Generated: \(report.createdAt.formatted(date: .abbreviated, time: .shortened))")

            if let owner = report.ownerName, !owner.isEmpty {
                draw("User: \(owner)")
            }

            
            cursor += 10

            if let summary = report.summary, !summary.isEmpty {
                draw("Summary", size: 18, bold: true)
                draw(summary)
                cursor += 5
            }

            for section in report.sections {
                draw(section.heading, size: 18, bold: true)
                draw(section.body)
                cursor += 5
            }



            if !report.sources.isEmpty {
                draw("Legal Sources", size: 18, bold: true)

                for source in report.sources {
                    draw("• \(source.title)", bold: true)

                    if let org = source.organisation, !org.isEmpty {
                        draw("Organisation: \(org)", size: 12)
                    }

                    draw("Link: \(source.url)", size: 12)

                    if !source.description.isEmpty {
                        draw(source.description, size: 12)
                    }

                    cursor += 5
                }
            }
        }

        try data.write(to: url)
    }
}


extension ExportableReport {

    init(from scenarioReport: ScenarioReport) {

        let summarySection = Section(
            heading: "Scenario Summary",
            body: scenarioReport.legalSummary)

        
        let responses = scenarioReport.steps
            .map { "• \($0.statement)" }
            .joined(separator: "\n")

        let responsesSection = Section(
            heading: "User Responses",
            body: responses
        )

        
        let sources = scenarioReport.legalSources.map {
            Source(
                title: $0.sourceTitle,
                url: $0.sourceUrl,
                description: $0.sourceDescription,
                organisation: $0.sourceOrganization
            )
        }

        
    self.init(
        title: scenarioReport.scenarioTitle,
        createdAt: scenarioReport.createdAt ?? Date(),
        ownerName: scenarioReport.userId,
        summary: nil,
        sections: [summarySection, responsesSection],
        sources: sources)
    }
}
