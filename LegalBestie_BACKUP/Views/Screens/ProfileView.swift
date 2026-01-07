//  ProfileView.swift
//  LegalBestie
//
//  Created by Carolina LC on 23/10/2025.

import FirebaseAuth
import SwiftUI

private let brandRose = Color(red: 0.965, green: 0.29, blue: 0.54)

struct ProfileView: View {
    let user: User?
    let onSignOut: () -> Void
    
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
                                    .frame(width: 44, height: 44)

                                Image(systemName: "person.fill")
                                    .foregroundStyle(brandRose)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text("My Profile")
                                    .font(.title3.weight(.semibold))

                                Text(user?.email ?? "Guest")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Text((user?.email != nil) ? "Verified" : "Guest")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(user?.email != nil ? .green : brandRose)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 10)
                                .background(
                                    Capsule().fill(Color.white.opacity(0.55))
                                )
                        }
                        .padding(.vertical, 6)
                    }
                    .listRowBackground(Color.clear)

                    Section("Account Info") {
                        LabeledContent("User ID", value: user?.userId ?? "-")
                        LabeledContent("Email", value: user?.email ?? "-")
                        LabeledContent("Account type", value: user == nil ? "Guest" : "Registered")
                    }

                    if user != nil {
                        Section {
                            Button("Resend verification email") {
                                Task {
                                    try? await  Auth.auth().currentUser?.sendEmailVerification()
                                }
                            }
                            .buttonStyle(.bordered)
                            .tint(brandRose)
                        } header: {
                            Text("Verify your email")
                        } footer: {
                            Text("Check your inbox for the verification link.")
                        }
                    }

                    Section {
                        Button(role: .destructive, action: onSignOut) {
                            Label("Sign out", systemImage: "arrow.backward.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                        }
                    }
                }
                .tint(brandRose)
                .scrollContentBackground(.hidden)
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
