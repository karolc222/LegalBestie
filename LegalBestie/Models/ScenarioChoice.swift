//  ScenarioChoice.swift
//  LegalBestie
//
//  Created by Carolina LC on 16/10/2025.

import Foundation
import SwiftData

public struct ScenarioChoice: Codable, Hashable {
    public let text: String
    public let nextNode: String
    
    public init(text: String, nextNode: String)
    {
        self.text = text
        self.nextNode = nextNode
    }
}

@Model
// store choices in the db
final class ScenarioChoiceModel {
    
    @Attribute(.unique) var choiceId: String
    var text: String
    var nextNode: String
    
    init(choiceId: String = UUID().uuidString, text: String, nextNode: String) {
        self.choiceId = choiceId
        self.text = text
        self.nextNode = nextNode
    }
}


