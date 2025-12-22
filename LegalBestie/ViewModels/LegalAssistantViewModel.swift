//
//  LegalAssistantViewModel.swift
//  LegalBestie
//
//  Created by Carolina LC on 21/12/2025.

import Foundation

@MainActor
final class LegalAssistantViewModel: ObservableObject {

    enum Role {
        case user
        case assistant
    }

    struct ChatItem: Identifiable {
        let id = UUID()
        let role: Role
        let text: String
    }

    @Published var items: [ChatItem] = []
    @Published var isLoading = false

    private let sourcesProvider = SourcesProvider()

    func send(question: String) async {
        let q = question.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return }

        items.append(ChatItem(role: .user, text: q))
        isLoading = true

        do {
            let sources = try await sourcesProvider.sources(for: q)
            let reply = try await ChatService.shared.askQuestion(
                question: q,
                sources: sources
            )
            items.append(ChatItem(role: .assistant, text: reply))
        } catch {
            items.append(ChatItem(role: .assistant, text: error.localizedDescription))
        }

        isLoading = false
    }
}
