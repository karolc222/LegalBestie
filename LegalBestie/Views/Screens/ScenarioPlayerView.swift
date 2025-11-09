//  ScenarioPlayerView.swift
//  LegalBestie
//
//  Created by Carolina LC on 09/11/2025.
// JSON decoder + player


import SwiftUI
import Foundation

private struct ScenarioTemplate: Codable {
    let scenarioId: String
}

private struct Node: Codable {
    
}

private struct Choice: Codable, Hashable {
    
}

private struct LegalSourceDTO: Codable, Hashable {
    
}

private func makeScenarioDecoder() -> JSONDecoder {
    
}

private func loadTemplate(category: String, name: String ) throws -> ScenarioTemplate {
    guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
        throw NSError(domain: "ScenarioPlayer", code: 1, userInfo: [NSLocalizedDescriptionKey : "Template not found"])
    }
}


