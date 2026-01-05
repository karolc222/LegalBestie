//  StepReport.swift
//  LegalBestie
//
//  Created by Carolina LC on 19/11/2025.

import Foundation
import SwiftData

@Model
final class StepReport {
    @Attribute(.unique) var stepId: String
    var scenarioId: String
    var question: String
    var userAnswer: String
    var statement: String
    
    init(
        stepId: String = UUID().uuidString,
        scenarioId: String,
        question: String,
        userAnswer: String,
        statement: String
        
    ){
        self.stepId = stepId
        self.scenarioId = scenarioId
        self.question = question
        self.userAnswer = userAnswer
        self.statement = statement
    }
}
