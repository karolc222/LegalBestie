//
//  LegalSourceViewModel.swift
//  LegalBuddy
//
//  Created by Carolina LC on 15/09/2025.
//

import Foundation

class LegalSourceViewModel: ObservableObject {
    @Published var sources: [LegalSource] = []

    init() {
        loadSources()
    }

    func loadSources() {
        guard let url = Bundle.main.url(forResource: "civil_rights_links", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decodedSources = try? JSONDecoder().decode([LegalSource].self, from: data) else {
            print("⚠️ Failed to load civil_rights_links.json")
            return
        }

        self.sources = decodedSources
    }
}
