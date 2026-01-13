//  GuestProfileView.swift
//  LegalBestie
//
//  Created by Carolina LC on 27/12/2025.

import SwiftUI

private let brandRose = Color(red: 0.965, green: 0.29, blue: 0.54)

struct GuestProfileView: View {
    let onSignIn: () -> Void
    
    
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [brandRose.opacity(0.10), Color(.systemBackground)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                
                List {
                    
                    Section {
                        HStack(spacing: 12) {
                            ZStack {
                                
                                Circle()
                                    .fill(brandRose.opacity(0.14))
                                    .frame(width: 48, height: 48)

                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundStyle(brandRose)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Guest User")
                                    .font(.title3.weight(.semibold))

                                Text("You’re browsing as a guest")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()
                        }
                        .padding(.vertical, 6)
                    }
                    .listRowBackground(Color.clear)
                    
                
                    
                    Section {
                        Button {
                            onSignIn()
                        } label: {
                            HStack {
                                Label("Sign In or Register", systemImage: "person.badge.plus")
                                    .font(.headline)

                                Spacer()

                                Image(systemName: "arrow.right.circle.fill")
                                    .foregroundStyle(brandRose)
                            }
                            .padding(.vertical, 6)
                        }
                        .buttonStyle(.plain)
                    } footer: {
                        Text("Create an account to save your scenario reports and access them across devices.")
                    }
                    
        
                    
                    Section {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("With an account you can:")
                                .font(.headline)

                            Label("Save scenario reports", systemImage: "checkmark.circle.fill")
                            Label("Access saved content", systemImage: "checkmark.circle.fill")
                            Label("Sync across devices", systemImage: "checkmark.circle.fill")
                        }
                        .foregroundStyle(.secondary)
                        .padding(12)
                    }
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color(.secondarySystemBackground))
                    )
                }
                .scrollContentBackground(.hidden)
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
