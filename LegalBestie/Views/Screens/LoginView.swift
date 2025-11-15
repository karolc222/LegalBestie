//  LoginView.swift
//  LegalBestie
//
//  Created by Carolina LC on 23/10/2025.

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var auth: AuthService
    @State private var email = ""
    @State private var password = ""
    @State private var message = ""
    @State private var isLoading = false
    
    @FocusState private var focused: Field?
    private enum Field { case email, password}
    
    var body: some View {
        NavigationView {
            Form{
                Section("Sign in") {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Password (min 7)", text: $password)
                        .focused($focused, equals : .password)
                    
                    
                    Button(isLoading ? "Signing in..." : "Sign in") {
                        focused = nil
                        print("Sign in tapped")
                        Task { await run { try await auth.signIn(email: email, password: password) }}
                    }
                    .disabled(isLoading || email.isEmpty || password.isEmpty)
                }
                    
                Section("New here?") {
                    Button(isLoading ? "Creating..." : "Create account") {
                        focused = nil
                        print ("create account tapped with email=\(email)")
                        Task { await run { try await auth.signUp(email: email, password: password)
                            message = "Verification email sent."
                        }}
                    }
                    .disabled(isLoading || email.isEmpty || password.count < 7)
                    
                    Button("Forgot password?") {
                        focused = nil
                        print("reset password ")
                        Task {
                            await run {
                                try await auth.sendPasswordReset(email: email)
                                message = "Password reset email sent."
                            }
                        }
                    }
                    .disabled(isLoading || email.isEmpty)
                }
                
                if !message.isEmpty {
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Welcome!")
        }
    }
    
    @MainActor
    private func run(_ action: @escaping () async throws -> Void) async {
        isLoading = true
        defer { isLoading = false }
        do { try await action() }
        catch {
            let ns = error as NSError
            switch ns.code {
            case AuthErrorCode.emailAlreadyInUse.rawValue: message = "This email is already registered."
            case AuthErrorCode.invalidEmail.rawValue: message = "Please enter a valid email address."
            case AuthErrorCode.weakPassword.rawValue: message = "Password must be at least 7 characters long."
            case AuthErrorCode.wrongPassword.rawValue: message = "Incorrect email or password."
            case AuthErrorCode.userNotFound.rawValue: message = "User not found."
            default: message = "An unknown error occurred."
            }
            print(" Authentication error (\ns.code)): \(ns.localizedDescription)")
        }
    }
}
