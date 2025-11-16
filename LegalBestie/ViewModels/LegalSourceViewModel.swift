//  LegalSourceViewModel.swift
//  LegalBestie
//
//  Created by Carolina LC on 15/09/2025.

//data model + adapter

import SwiftData
import Foundation

struct LegalSourceDTO: Decodable {
    let sourceTitle: String
    let sourceUrl: URL
    let sourceDescription: String
    let sourceOrganization: String?
    let sourceStatus: String?
    let sourceKeywords: [String]?
    let topics: [String]?
}

class LegalSourceViewModel: ObservableObject {
    @Published var sources: [LegalSource] = []
    
    init() {
        loadSources()
    }
    
    func loadSources() {
        guard let url = Bundle.main.url(forResource: "civil_rights_links", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decodedSources = try? JSONDecoder().decode([LegalSourceDTO].self, from: data) else {
            print("⚠️ Failed to load civil_rights_links.json")
            return
        }
        
        self.sources = decodedSources.map {
            LegalSource(dto: $0)
        }
    }
}
