//  ScenarioListViewModel.swift
//  LegalBestie
//
//  Created by Carolina LC on 07/11/2025.

import Foundation

@MainActor
final class ScenarioListViewModel: ObservableObject {
    
    @Published var scenarios: [ScenarioListItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func loadScenarios() async {
        isLoading = true
        errorMessage = nil
        
        // loading JSON files
        guard let urls = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: nil),
              !urls.isEmpty else {
            errorMessage = "No JSON files found"
            isLoading = false
            return
        }
    
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = Locale(identifier: "en_GB")
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        var loaded: [ScenarioListItem] = []
        
        for url in urls {
            let fileName = url.deletingPathExtension().lastPathComponent
            
            if fileName == "scenario_format" || fileName == "civil_rights_links" {
                continue
            }
                        
            guard let data = try? Data(contentsOf: url),
                  let template = try? decoder.decode(ScenarioTemplate.self,from: data) else {
                continue
            }
            
            loaded.append(
                ScenarioListItem(
                    fileName: fileName,
                    title: template.scenarioTitle,
                    description: template.scenarioDescription,
                    updatedAt: template.scenarioUpdatedAt ?? Date()
                )
            )
        }
        scenarios = loaded.sorted { $0.title < $1.title }
        
        if scenarios.isEmpty {
            errorMessage = "No scenarios found"
        }
    
        isLoading = false
    }
}
