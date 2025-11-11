//  Choice.swift
//  LegalBestie
//
//  Created by Carolina LC on 16/10/2025.

import Foundation

public struct ScenarioChoice: Codable, Hashable {
    public let text: String
    public let nextNode: String
    
    public init(text: String, nextNode: String)
    {
        self.text = text
        self.nextNode = nextNode
    }
}
