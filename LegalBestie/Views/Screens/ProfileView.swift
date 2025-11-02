//
//  ProfileView.swift
//  LegalBuddy
//
//  Created by Carolina LC on 23/10/2025.
//

import Foundation
import FirebaseAuth
import SwiftUI

struct ProfileView: View {
    let user: AuthService.AppUser
    let onSignOut: () -> Void
    
    var body: some View {
        NavigationView {
            List {
                Section("Account Info") {
                    LabeledContent("User ID", value: user.id)
                    LabeledContent("Email", value: user.email ?? "-")
                    LabeledContent("Email verified", value: user.isVerified ? "Yes" : "No")
                }
                
                if !user.isVerified {
                    Section {
                        Button("Resend verification email") {
                            Task {
                                try? await  Auth.auth().currentUser?.sendEmailVerification()
                            }
                        }
                        
                    } header: {
                        Text("Verify your email")
                    } footer: {
                        Text("Check your inbox for the verification link. ")
                    }
                }
                
                Section {
                    Button(role: .destructive, action: onSignOut) {
                        Label("Sign out", systemImage: "arrow.backward.circle.fill")
                    }
                }
            }
            .navigationTitle("My profile")
        }
    }
}
