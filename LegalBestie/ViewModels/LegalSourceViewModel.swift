//  LegalSourceViewModel.swift
//  LegalBestie
//
//  Created by Carolina LC on 15/09/2025.

// data loader + adapter

import Foundation

final class LegalSourceViewModel: ObservableObject {

    @Published private(set) var sources: [LegalSource] = []

    init() { loadSources()
    }

    
    func loadSources() {
        guard let url = Bundle.main.url(
            forResource: "civil_rights_links",
            withExtension: "json"
        ) else {
            print("file not found")
            sources = []
            return
        }

        
        // decode JSON
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([LegalSourceDTO].self, from: data)

            sources = decoded.map { dto in
                LegalSource(
                    sourceTitle: dto.sourceTitle,
                    sourceUrl: dto.sourceUrl.absoluteString,
                    sourceDescription: dto.sourceDescription,
                    sourceOrganization: dto.sourceOrganization ?? "",
                    sourceStatus: dto.sourceStatus ?? "",
                    sourceKeywords: dto.sourceKeywords ?? [],
                    sourceTopics: dto.sourceTopics ?? []
                )
            }
        } catch {
            print("Failed to load sources", error)
            sources = []
        }
    }
}
