//  ChatService.swift
//  LegalBestie
//
//  Created by Carolina LC on 28/11/2025.

import Foundation

class ChatService {
    static let shared = ChatService()
    
    private let apiKey: String
    
    init() {
        self.apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? ""
        
        if apiKey.isEmpty {
            print("API key not set")
        }
    }
    
    func askQuestion(
        question: String,
        sources: [(sourceTitle: String, sourceDescription: String)]
        ) async throws -> String {
        
        guard !apiKey.isEmpty else {
            return "Error: OpenAI API key not set."
        }
        
        let context = sources.isEmpty
            ? "Answer based on general UK law knowledge."
            : sources
                .map { "Source: \($0.sourceTitle)\n\($0.sourceDescription)" }
                .joined(separator: "\n\n")
        
        let prompt = """
        You are a helpful UK legal assistant. Answer this question clearly and simply:
        
        \(context)
        
        Question: \(question)
        
        Keep your answer to 2-3 short sentences. Be helpful and clear.
        """
        
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "user", "content": prompt]
            ],
            "max_tokens": 200,
            "temperature": 0.7
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NSError(
                domain: "ChatService",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "API request failed"]
            )
        }
        
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let choices = json["choices"] as! [[String: Any]]
        let message = choices[0]["message"] as! [String: Any]
        let answer = message["content"] as! String
        
        return answer.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
