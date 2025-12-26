//  LegalAssistantView.swift
//  LegalBestie
//
//  Created by Carolina LC on 15/11/2025.

import SwiftUI
import SwiftData

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

struct LegalAssistantView: View {
    @Query private var legalSources: [LegalSource]
    @State private var messages: [Message] = []
    @State private var input = ""
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            //message bubbles
            ScrollView {
                ForEach(messages) { message in
                    HStack {
                        if message.isUser { Spacer()}
                        Text(message.text)
                            .padding()
                            .background(message.isUser ? Color.pink : Color.gray)
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                        if !message.isUser { Spacer()}
                    }
                    .padding(.horizontal)
                }
                
                if isLoading {
                    ProgressView()
                }
            }
            
            //user input
            HStack {
                TextField("What's up Bestie?", text: $input)
                    .textFieldStyle(.roundedBorder)
                
                Button("send") {
                    send()
                }
                .disabled(input.isEmpty || isLoading)
            }
            .padding()
        }
        .navigationTitle("Legal Bestie Assistant")
    }
    
    func send() {
        let question = input
        
        // Append user message
        messages.append(Message(text: question, isUser: true))
        input = ""
        isLoading = true
        
        Task {
            do {
                let relevant = findRelevantSources(for: question)
                
                // Call your ChatService with the current question and legal sources
                let answer = try await ChatService.shared.askQuestion(
                    question: question,
                    sources: Array(relevant.prefix(3)).map {
                        (sourceTitle: $0.sourceTitle, sourceDescription: $0.sourceDescription + "\nURL: \($0.sourceUrl)")
                    }
                )
                
                messages.append(Message(text: answer, isUser: false))
                isLoading = false
                
            } catch {
                messages.append(
                    Message(
                        text: "Sorry, something went wrong: \(error.localizedDescription)", isUser: false))
                isLoading = false
            }
        }
    }
    
    func findRelevantSources(for question: String) -> [LegalSource] {
        let q = question .lowercased()
        
        return legalSources.filter { source in
            // Police
            (q.contains("police") || q.contains("stop") || q.contains("search")) &&
            (source.sourceTopics.contains("police_stop") ||
             source.sourceTopics.contains("stop_and_search")) ||
            
            // Housing
            (q.contains("landlord") || q.contains("rent") || q.contains("deposit") || q.contains("housing")) &&
            (source.sourceTopics.contains("housing_rights") ||
             source.sourceTopics.contains("tenancy_deposit")) ||
            
            // Civil rights
            (q.contains("rights") || q.contains("legal")) &&
            source.sourceTopics.contains("civil_rights")
        }
    }
}
