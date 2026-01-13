//  ChatService.swift
//  LegalBestie
//
//  Created by Carolina LC on 28/11/2025.

import Foundation

@MainActor
final class ChatService {

    static let shared = ChatService()

    private let session: URLSession
    private let apiKey: String

    
    private init() {
        let config = URLSessionConfiguration.ephemeral
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 30
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        self.session = URLSession(configuration: config)

        self.apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? ""
        if apiKey.isEmpty { print("OPENAI_API_KEY missing.")
        }
    }

    func askQuestion(
        question: String,
        sources: [(sourceTitle: String, sourceDescription: String)]
        
        
    ) async throws -> String {

        guard !apiKey.isEmpty else {
            return "AI is unavailable or its missing."
        }

        let context = sources.isEmpty
            ? "Answer based on general UK law knowledge."
            : sources.map {
                "Source: \($0.sourceTitle)\n\($0.sourceDescription)"
              }.joined(separator: "\n\n")

        
        let prompt = """
        You are a helpful UK legal assistant.

        \(context)

        Question: \(question)

        Answer clearly in 2–3 short sentences.
        """

        var request = URLRequest(
            url: URL(string: "https://api.openai.com/v1/chat/completions")!
        )
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        request.httpBody = try JSONSerialization.data(withJSONObject: [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "user", "content": prompt]
            ],
            "max_tokens": 200,
            "temperature": 0.7
        ])

        
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw ChatError.network
        }

        guard (200...299).contains(http.statusCode) else {
            throw ChatError.http(http.statusCode)
        }

        guard
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
            let choice = (json["choices"] as? [[String: Any]])?.first,
            let message = choice["message"] as? [String: Any],
            let content = message["content"] as? String
        else {
            throw ChatError.decode
        }

        return content.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// error handling
enum ChatError: LocalizedError {
    case network
    case decode
    case http(Int)

    var errorDescription: String? {
        switch self {
        case .network:
            return "Network error."
        case .decode:
            return "AI response could not be parsed."
        case .http(let code):
            return "AI request failed (\(code))."
        }
    }
}
