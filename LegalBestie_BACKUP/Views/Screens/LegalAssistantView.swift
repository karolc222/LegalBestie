//  LegalAssistantView.swift
//  LegalBestie
//
//  Created by Carolina LC on 15/11/2025.

import SwiftUI

private let brandRose = Color(red: 0.965, green: 0.29, blue: 0.54) // #f64a8a-inspired

struct LegalAssistantView: View {
    @StateObject private var viewModel = LegalAssistantViewModel()
    @State private var input = ""

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [brandRose.opacity(0.10), Color(.systemBackground)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {

                // Messages
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.items) { item in
                            HStack {
                                if item.role == .user { Spacer(minLength: 24) }

                                Text(item.text)
                                    .font(.callout)
                                    .foregroundStyle(item.role == .user ? .white : .primary)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                                            .fill(item.role == .user ? brandRose : Color.white)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                                            .stroke(item.role == .user ? Color.clear : brandRose.opacity(0.18), lineWidth: 1)
                                    )
                                    .frame(maxWidth: 260, alignment: item.role == .user ? .trailing : .leading)

                                if item.role == .assistant { Spacer(minLength: 24) }
                            }
                            .padding(.horizontal, 16)
                        }

                        if viewModel.isLoading {
                            HStack {
                                ProgressView()
                                Text("Thinking…")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 4)
                        }
                    }
                    .padding(.vertical, 14)
                }

                // Input bar
                VStack(spacing: 10) {
                    Divider().opacity(0.15)

                    HStack(spacing: 10) {
                        TextField("Ask me a legal question!", text: $input)
                            .textFieldStyle(.plain)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Color.white)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(brandRose.opacity(0.18), lineWidth: 1)
                            )

                        
                        Button {
                            let q = input
                            input = ""
                            
                            Task { await viewModel.send(question: q) }
                            
                        } label: {
                            Image(systemName: "arrow.up")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(width: 40, height: 40)
                                .background(
                                    Circle().fill(brandRose)
                                )
                        }
                        .disabled(input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isLoading)
                        .opacity((input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isLoading) ? 0.5 : 1.0)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)
                }
            }
        }
        .navigationTitle("Assistant")
        .navigationBarTitleDisplayMode(.inline)
    }
}
