//  ChatService.swift
//  LegalBestie
//
//  Created by Carolina LC on 28/11/2025.

import Foundation

class ChatService {
    static let shared = ChatService()

    private let session: URLSession = {
        let config = URLSessionConfiguration.ephemeral
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 30
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        return URLSession(configuration: config)
    }()

    private let apiKey: String

    init() {
        self.apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? ""

        if apiKey.isEmpty {
            print("OPENAI_API_KEY is NOT set for this run.")
        } else {
            print("OPENAI_API_KEY loaded. Prefix: \(apiKey.prefix(7))…")
        }
    }
    
    func askQuestion(
        question: String,
        sources: [(sourceTitle: String, sourceDescription: String)]
        ) async throws -> String {
        
        guard !apiKey.isEmpty else {
            return "AI is unavailable (missing API key)."
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
        request.setValue("application/json", forHTTPHeaderField: "Accept")
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

        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            print("OpenAI: non-HTTP response")
            throw NSError(domain: "ChatService", code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Network error (non-HTTP response)."])
        }

        // Helpful debug output
        let raw = String(data: data, encoding: .utf8) ?? "<no body>"
        if !(200...299).contains(http.statusCode) {
            print("OpenAI HTTP \(http.statusCode). Body: \(raw)")

            // Return a readable message based on common failures
            let message: String
            switch http.statusCode {
            case 401:
                message = "OpenAI request failed (401). Check API key / billing."
            case 403:
                message = "OpenAI request blocked (403)."
            case 404:
                message = "OpenAI endpoint/model not found (404)."
            case 429:
                message = "OpenAI rate limit reached (429). Try again."
            default:
                message = "OpenAI request failed (\(http.statusCode))."
            }

            throw NSError(domain: "ChatService", code: http.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: message])
        }
        
        guard
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
            let choices = json["choices"] as? [[String: Any]],
            let firstChoice = choices.first,
            let message = firstChoice["message"] as? [String: Any],
            let answer = message["content"] as? String
        else {
            let raw = String(data: data, encoding: .utf8) ?? "<no body>"
            print("OpenAI decode/shape mismatch. Raw: \(raw)")
            return "OpenAI response could not be parsed."
        }

        return answer.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
