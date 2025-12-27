//  GuestProfileView.swift
//  LegalBestie
//
//  Created by Carolina LC on 27/12/2025.

import Foundation
import SwiftUI

struct GuestProfileView: View {
    let onSignIn: () -> Void
    
    var body: some View {
        NavigationStack {
            List {
                // Guest Status
                Section {
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Guest User")
                                .font(.headline)
                            Text("Not signed in")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Sign In/Register
                Section {
                    Button {
                        onSignIn()
                    } label: {
                        HStack {
                            Label("Sign In or Register", systemImage: "person.badge.plus")
                            Spacer()
                            Image(systemName: "arrow.right")
                                .foregroundStyle(.secondary)
                        }
                    }
                } footer: {
                    Text("Create an account to save your scenario reports and access them across devices.")
                }
                
                // What they're missing
                Section("With an account you can:") {
                    Label("Save scenario reports", systemImage: "checkmark.circle")
                    Label("Access saved content", systemImage: "checkmark.circle")
                    Label("Sync across devices", systemImage: "checkmark.circle")
                }
                .foregroundStyle(.secondary)
            }
            .navigationTitle("Profile")
        }
    }
}
