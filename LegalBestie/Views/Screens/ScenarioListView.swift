//  ScenarioListView.swift
//  LegalBestie
//
//  Created by Carolina LC on 07/11/2025.

import Foundation
import SwiftUI

//minimal shape to read list metadata from each JSON
private struct ScenarioHeader: Decodable {
    let scenarioId: String
    let scenarioTitle: String
    let scenarioDescription: String
    let scnearioUpdatedAt: String
}

//one row in the list
private struct ScenarioListItem: Identifiable {
    let scenarioId = UUID()
    let fileName : String
    let fileTitle: String
    let fileDescription: String
    let fileUpdatedAt: Date
}

struct ScenarioListView: View {
    let category: String
    @State private var items: [ScenarioListItem] = []
    @State private var errorText: String?
    
    
    var body: some View {
        List(items) { item in
            NavigationLink(destination: Text(item.title)) {
                VStack(alignement: .leading) {
                    Text(item.title).font(.headline)
                    Text(item.description).font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle(category)
        .task { await load() }
    }
    private func load() async {
        do {
            guard let urls = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: "JSON/\(category)") else {
                return
            }
            let decoder = JSON decoder()
            let df = DateFormatter()
            
        }
    }
}
