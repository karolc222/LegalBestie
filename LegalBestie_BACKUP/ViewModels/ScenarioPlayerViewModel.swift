//  ScenarioPlayerViewModel.swift
//  LegalBestie
//
//  Created by Carolina LC on 31/12/2025.

import Foundation
import SwiftData

@MainActor
final class ScenarioPlayerViewModel: ObservableObject {
    
    @Published var template: ScenarioTemplate?
    @Published var currentKey: String = ""
    @Published var errorText: String?
    @Published var userResponses: [UserResponse] = []
    @Published var report: ScenarioReport?
    @Published var showOutcome = false
    
    private let category: String
    private let name: String
    
    init(category: String, name: String) {
        self.category = category
        self.name = name
    }
    
    
    func loadScenario() async {
        do {
            let t = try await Task.detached(priority: .userInitiated) { [category, name] in
                try await ScenarioPlayerViewModel.loadTemplate(category: category, name: name)
            }.value

            template = t
            currentKey = t.startNode
            errorText = nil
        } catch {
            errorText = error.localizedDescription
        }
    }
    
    func selectChoice(question: String, answer: String, nextNode: String) {
        recordAnswer(question: question, answer: answer)
        currentKey = nextNode
    }
    
    func generateReport() {
        guard let template else {
            print("No template available")
            return
        }
        
        
        
        // Convert responses to StepReports with statements
        let steps = userResponses.map { response in
            let statement = convertToStatement(
                question: response.question,
                answer: response.answer
            )
            return StepReport(
                scenarioId: template.scenarioId,
                question: response.question,
                userAnswer: response.answer,
                statement: statement
            )
        }
        
        // Create report
        report = ScenarioReport(
            userId: "guest",
            scenarioId: template.scenarioId,
            scenarioTitle: template.scenarioTitle,
            createdAt: Date(),
            updatedAt: Date(),
            steps: steps,
            legalSummary: template.legalSummaryText,
            legalSources: [],
        )
        
        print("Report created successfully")
        showOutcome = true
    }
    
    func saveReport(to modelContext: ModelContext) {
        guard let report else { return }
        modelContext.insert(report)
        try? modelContext.save()
    }
    
    var currentNode: ScenarioNode? {
        guard let template else { return nil }
        return template.nodes[currentKey]
    }
    
    var isOutcomeNode: Bool {
        currentNode?.choices.isEmpty ?? false
    }
    
    
    private static func loadTemplate(category: String, name: String) throws -> ScenarioTemplate {
        guard let url = Bundle.main.url(
            forResource: name,
            withExtension: "json",
            subdirectory: nil
        ) else {
            throw NSError(
                domain: "ScenarioPlayer",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Template not found: \(name).json"]
            )
        }
        
        let data = try Data(contentsOf: url)
        return try makeScenarioDecoder().decode(ScenarioTemplate.self, from: data)
    }
    
    private func recordAnswer(question: String, answer: String) {
        let response = UserResponse(question: question, answer: answer)
        userResponses.append(response)
    }
    
    private static func makeScenarioDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.timeZone = TimeZone(identifier: "Europe/London")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
    
    private func convertToStatement(question: String, answer: String) -> String {
        let choice = answer.lowercased()
        var statement = question
            .replacingOccurrences(of: "?", with: "")
            .trimmingCharacters(in: .whitespaces)
        
        
        if choice == "yes" {
            statement = statement.replacingOccurrences(of: "Did the ", with: "The ")
            statement = statement.replacingOccurrences(of: "Did ", with: "")
            statement = statement.replacingOccurrences(of: "Did your ", with: "My ")
            statement = statement.replacingOccurrences(of: "Were you ", with: "I was ")
            statement = statement.replacingOccurrences(of: "Was the ", with: "The ")
            statement = statement.replacingOccurrences(of: "Was your ", with: "My ")
            statement = statement.replacingOccurrences(of: "Does the ", with: "The ")
            
            let verbReplacements = [
                " ask ": " asked ",
                " request ": " requested ",
                " attempt ": " attempted ",
                " refuse ": " refused ",
                " provide ": " provided ",
                " stop ": " stopped ",
                " seize ": " seized ",
                " send ": " sent ",
                " show ": " showed ",
                " protect ": " protected "
            ]
            
            for (verb, pastTense) in verbReplacements {
                statement = statement.replacingOccurrences(
                    of: verb,
                    with: pastTense,
                    options: .caseInsensitive
                )
            }
            
        } else if choice == "no" {
            statement = statement.replacingOccurrences(of: "Did the ", with: "The ")
            statement = statement.replacingOccurrences(of: "Did ", with: "")
            statement = statement.replacingOccurrences(of: "Did your ", with: "My ")
            statement = statement.replacingOccurrences(of: "Were you ", with: "I was not ")
            statement = statement.replacingOccurrences(of: "Was the ", with: "The ")
            statement = statement.replacingOccurrences(of: "Was your ", with: "My ")
            statement = statement.replacingOccurrences(of: "Does the ", with: "The ")
            
            // Add negation
            let verbs = [
                "ask", "request", "attempt", "refuse", "provide",
                "stop", "seize", "delete", "pressure", "send", "show", "protect"
            ]
            
            for verb in verbs {
                if statement.lowercased().contains(" \(verb) ") {
                    statement = statement.replacingOccurrences(
                        of: " \(verb) ",
                        with: " did not \(verb) ",
                        options: .caseInsensitive
                    )
                    break
                }
            }
        } else {
            return "\(question): \(answer)"
        }
        
        return statement.prefix(1).uppercased() + statement.dropFirst()
    }
}
