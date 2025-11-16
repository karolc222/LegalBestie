import SwiftUI

struct ScenarioOutcomeView: View {
    let title: String
    let description: String
    let legalSummary: String?
    let topics: [String]
    
    @StateObject private var legalSourceViewModel = LegalSourceViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                Text(title)
                    .font(.title2.bold())
                
                Text(description)
                    .font(.body)
                
                if let summary = legalSummary {
                    Divider()
                    Text("Legal summary")
                        .font(.headline)
                    
                    Text(summary)
                        .font(.body)
                }
                
                // legal sources from JSON
                let filteredSources = legalSourceViewModel.sources.filter { src in !Set(src.sourceTopics).isDisjoint(with:topics)}
                if !filteredSources.isEmpty {
                                                                                                                      
                    Divider()
                    Text("Related Legal Sources")
                        .font(.headline)
                    
                    ForEach(filteredSources) { src in
                        VStack(alignment: .leading, spacing: 6) {
                            
                            Text(src.sourceTitle)
                                .font(.subheadline.bold())
                            
                            if let url = src.urlValue {
                                Link("Open Source", destination: url)
                                    .font(.caption)
                            }
                            
                            if !src.sourceOrganization.isEmpty {
                                Text(src.sourceOrganization)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            
                            if !src.sourceStatus.isEmpty {
                                Text(src.sourceStatus)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                
                            }
                        }
                        
                        .padding(.vertical, 4)
                    }
                }
            }
            .padding()
        }
            navigationTitle("Outcome")
                .navigationBarTitleDisplayMode(.inline)
        }
    }



