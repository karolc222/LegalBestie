//  LegalSourceViewModel.swift
//  LegalBestie
//
//  Created by Carolina LC on 15/09/2025.

// data model + adapter

import SwiftData
import Foundation
    
    class LegalSourceViewModel: ObservableObject {
        @Published var sources: [LegalSource] = []
        
        init() {
            loadSources()
        }
        
        func loadSources() {
            // 1. Locate JSON
            guard let url = Bundle.main.url(
                forResource: "civil_rights_links",
                withExtension: "json"
            ) else {
                print("⚠️ civil_rights_links.json not found in bundle")
                return
            }
            
            do {
                // 2. Read file
                let data = try Data(contentsOf: url)
                
                // 3. Decode DTOs
                let decodedSources = try JSONDecoder().decode([LegalSourceDTO].self, from: data)
                print("Loaded sources from JSON:", decodedSources.count)
                
                // 4. Map DTOs → LegalSource model
                self.sources = decodedSources.map { dto in
                    LegalSource(
                        //sourceId: UUID().uuidString,
                        sourceTitle: dto.sourceTitle,
                        sourceUrl: dto.sourceUrl.absoluteString,
                        sourceDescription: dto.sourceDescription,
                        sourceOrganization: dto.sourceOrganization ?? "",
                        sourceStatus: dto.sourceStatus ?? "",
                        sourceKeywords: dto.sourceKeywords ?? [],
                        sourceTopics: dto.sourceTopics ?? []
                    )
                }
                print("✅ Adapted to \(self.sources.count) LegalSource models")

            } catch {
                print("⚠️ Failed to decode civil_rights_links.json:", error)
                self.sources = []
            }
        }
    }


     
