//  LegalAssistantView.swift
//  LegalBestie
//
//  Created by Carolina LC on 15/11/2025.

import SwiftUI

struct LegalAssistantView: View {
    @State private var input: String = ""

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Legal Assistant")
                    .font(.title2.bold())

                Text("Ask a question about your rights. This is a placeholder view for now.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()

                VStack(spacing: 8) {
                    TextField("Type your question here…", text: $input, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(1...4)

                    Button("Send") {
                        // Later: call your ChatQuery / OpenAI logic
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            .navigationTitle("Assistant")
        }
    }
}
