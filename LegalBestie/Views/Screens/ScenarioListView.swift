//
//  ScenarioListView.swift
//  LegalBestie
//
//  Created by Carolina LC on 07/11/2025.

import Foundation
import SwiftUI
import SwiftData

struct ScenarioListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Scenario.updatedAt, order: .reverse)
    private var scenarios: [Scenario]
    
    var body: some View {
        
    }
}
