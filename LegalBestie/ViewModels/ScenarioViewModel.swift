//
//  ScenarioViewModel.swift
//  LegalBuddy
//
//  Created by Carolina LC on 11/09/2025.
//

import Foundation

class ScenarioViewModel: ObservableObject {
    @Published var scenario: Scenario?

    init(filename: String = "journalists/stopped_by_police") {
        loadScenario(named: filename)
    }

    func loadScenario(named name: String) {
        if let url = Bundle.main.url(forResource: name, withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let loadedScenario = try? JSONDecoder().decode(Scenario.self, from: data) {
            DispatchQueue.main.async {
                self.scenario = loadedScenario
            }
        } else {
            print("❌ Failed to load scenario named \(name)")
        }
    }
}
