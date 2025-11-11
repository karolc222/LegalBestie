//  ScenarioViewModel.swift
//  LegalBestie
//
//  Created by Carolina LC on 11/09/2025.

import Foundation

class ScenarioViewModel: ObservableObject {
    @Published var scenario: Scenario?

    init(filename: String = "journalists/stopped_by_police") {
        loadScenario(named: filename)
    }

    func loadScenario(named name: String) {
        struct ScenarioTemplateDTO: Decodable {
            let scenarioId: String
            let title: String
            let categoryId: String
            let description: String
            let startNode: String
            let nodes: [String: NodeDTO]
            let legalSummaryText: String
            let updatedAt: String
        }
        
        struct NodeDTO : Decodable {
            let question: String
            let choices: [ChoiceDTO]?
        }
        
        struct ChoiceDTO : Decodable {
            let label: String
            let nextNode: String
        }
        
        
        if let url = Bundle.main.url(forResource: name, withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            let df = DateFormatter()
            df.calendar = .init(identifier: .iso8601)
            df.locale = .init(identifier: "en_GB")
            df.timeZone = .init(identifier: "Europe/London")
            df.dateFormat = "dd-MM-yyyy"
            decoder.dateDecodingStrategy = .formatted(df)
            
            if let loaded = try? decoder.decode(ScenarioTemplateDTO.self, from: data) {
                DispatchQueue.main.async {
                    //self.template = loaded
                }
            } else {
                print("Decoding failed for \(name)")
            }
                
        }
    }
}
