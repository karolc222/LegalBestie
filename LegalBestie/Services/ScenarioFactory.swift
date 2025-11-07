//
//  ScenarioFactory.swift
//  LegalBestie
//
//  Created by Carolina LC on 06/11/2025.

import Foundation

struct ScenarioTemplate {
    let startNode: String
    let nodes: [String: ScenarioNode]
    let sources: [String]
}

//data transfer objects for decoding JSON, describes how the JSON is structured
private struct OptionDTO: Codable {
    let text: String
    let nextNode: String
}

private struct ScenarioNodeDTO: Codable {
    let text: String
    let options: [OptionDTO]
}

private struct ScenarioTemplateDTO: Codable {
    let startNode: String
    let nodes: [String: ScenarioNodeDTO]
    let sources: [String]
}

enum ScenarioFactory {
    //cache=small memory store
    private static var cache: [String: ScenarioTemplate] = [:]
    
    //load a JSON template
    static func template(for category: String, name: String) -> ScenarioTemplate {
        let key = "\(category)/\(name)"
        if let cachedTemplate = cache[key] {
            return cachedTemplate
        }
        
        //guard checks a condition, tries to unwrap an optional
        //url = location of the JSON file inside app bundle
        guard let url = Bundle.main.url(
            forResource: name,
            withExtension: "json",
            subdirectory: "JSON/\(category)"
        ) else {
            return ScenarioTemplate(startNode: "", nodes: [:], sources: [])
        }
        
        do {
            let data = try Data(contentsOf: url)
            let dto = try JSONDecoder().decode(ScenarioTemplateDTO.self, from: data)
            let mappedNodes: [String: ScenarioNode] = dto.nodes.reduce(into: [:]) { result, element in
                let (key, nodeDTO) = element
                let choices = nodeDTO.options.map { ScenarioChoice(text: $0.text, nextNode: $0.nextNode) }
                // If your model uses `choices:` instead of `options:`, change the label below.
                result[key] = ScenarioNode(text: nodeDTO.text, options: choices)
            }
            let tpl = ScenarioTemplate(
                startNode: dto.startNode,
                nodes: mappedNodes,
                sources: dto.sources
            )
            cache[key] = tpl
            return tpl
        } catch {
            return ScenarioTemplate(startNode: "", nodes: [:], sources: [])
        }
    }
}
