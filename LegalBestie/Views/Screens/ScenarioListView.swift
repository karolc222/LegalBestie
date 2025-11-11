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
    let scenarioName: String
    let scenarioDescription: String
    let scnearioUpdatedAt: String
}

//one row in the list
private struct ScenarioListItem: Identifiable {
    let scenarioId = UUID()
    let scenarioName : String
    let scenarioTitle: String
    let scenarioDescription: String
    let scenarioUpdatedAt: Date
}

struct ScenarioListView: View {
    let category: String
    
    
    var body: some View {
        Text("Scenario list will apear here ")
    }
}
