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
        print("🔍 Starting to load scenarios...")
        isLoading = true
        errorMessage = nil
        
        // Get JSON files
        let urls = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: nil)
        print("📁 Found \(urls?.count ?? 0) JSON files")
        
        guard let urls = urls, !urls.isEmpty else {
            print("❌ No JSON files found in bundle")
            errorMessage = "No files found"
            isLoading = false
            return
        }
        
        // Print all files found
        for url in urls {
            print("   📄 \(url.lastPathComponent)")
        }
        
        // Setup decoder
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = Locale(identifier: "en_GB")
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        // Load each scenario
        var loaded: [ScenarioListItem] = []
        
        for url in urls {
            let fileName = url.deletingPathExtension().lastPathComponent
            
            // Skip non-scenario files
            if fileName == "scenario_format" || fileName == "civil_rights_links" {
                print("⏭️  Skipping: \(fileName)")
                continue
            }
            
            print("🔄 Trying to decode: \(fileName)")
            
            // Try to load
            guard let data = try? Data(contentsOf: url) else {
                print("❌ Could not read data from: \(fileName)")
                continue
            }
            
            print("   ✓ Data loaded, size: \(data.count) bytes")
            
            guard let template = try? decoder.decode(ScenarioTemplate.self, from: data) else {
                print("❌ Could not decode: \(fileName)")
                do {
                    _ = try decoder.decode(ScenarioTemplate.self, from: data)
                } catch {
                    print("   Error: \(error)")
                }
                continue
            }
            
            print("   ✅ Decoded successfully: \(template.scenarioTitle)")
            
            // Add to list
            loaded.append(
                ScenarioListItem(
                    fileName: fileName,
                    title: template.scenarioTitle,
                    description: template.scenarioDescription,
                    updatedAt: template.scenarioUpdatedAt ?? Date()
                )
            )
        }
        
        print("📊 Total scenarios loaded: \(loaded.count)")
        
        // Sort and update
        scenarios = loaded.sorted { $0.title < $1.title }
        
        if scenarios.isEmpty {
            print("⚠️  No valid scenarios found")
            errorMessage = "No scenarios found"
        } else {
            print("✅ Successfully loaded \(scenarios.count) scenarios")
        }
        
        isLoading = false
    }
}
