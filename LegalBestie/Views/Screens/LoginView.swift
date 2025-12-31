//  LoginView.swift
//  LegalBestie
//
//  Created by Carolina LC on 23/10/2025.


import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var auth: AuthService
    var onContinueAsGuest: (() -> Void)? = nil
    
    @State private var email = ""
    @State private var password = ""
    @State private var message = ""
    @State private var isLoading = false
    
    @FocusState private var focused: Bool
    
    var body: some View {
        NavigationView {
            Form {
                // Sign In
                Section("SIGN IN") {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .focused($focused)
                    
                    SecureField("Enter password", text: $password)
                        .focused($focused)
                    
                    Button(isLoading ? "Signing in..." : "Sign in") {
                        focused = false
                        Task { await signIn() }
                    }
                    .disabled(isLoading || email.isEmpty || password.isEmpty)
                }
                
                // Register
                Section("NEW HERE?") {
                    Button(isLoading ? "Creating..." : "Create account") {
                        focused = false
                        Task { await signUp() }
                    }
                    .disabled(isLoading || email.isEmpty || password.count < 7)
                    
                    Button("Forgot password?") {
                        focused = false
                        Task { await resetPassword() }
                    }
                    .disabled(isLoading || email.isEmpty)
                }
                
                // Guest
                if let guestAction = onContinueAsGuest {
                    Section {
                        Button {
                            focused = false
                            guestAction()
                        } label: {
                            HStack {
                                Image(systemName: "person.fill.questionmark")
                                Text("Continue as Guest")
                            }
                            
                        }  } header: {
                            Text("BROWSE WITHOUT AN ACCOUNT")
                        } footer: {
                        Text("You can explore the app but won't be able to save reports.")
                    }
                }
                
                // Message
                if !message.isEmpty {
                    Section {
                        Text(message)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Welcome")
        }
    }
    
    // MARK: - Actions
    
    private func signIn() async {
        isLoading = true
        do {
            try await auth.signIn(email: email, password: password)
        } catch {
            handleError(error)
        }
        isLoading = false
    }
    
    private func signUp() async {
        isLoading = true
        do {
            try await auth.signUp(email: email, password: password)
            message = "Verification email sent."
        } catch {
            handleError(error)
        }
        isLoading = false
    }
    
    private func resetPassword() async {
        isLoading = true
        do {
            try await auth.sendPasswordReset(email: email)
            message = "Password reset email sent."
        } catch {
            handleError(error)
        }
        isLoading = false
    }
    
    private func handleError(_ error: Error) {
        let code = (error as NSError).code
        switch code {
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            message = "Email already registered."
        case AuthErrorCode.invalidEmail.rawValue:
            message = "Invalid email address."
        case AuthErrorCode.weakPassword.rawValue:
            message = "Password must be 7+ characters."
        case AuthErrorCode.wrongPassword.rawValue, AuthErrorCode.userNotFound.rawValue:
            message = "Incorrect email or password."
        default:
            message = "An error occurred."
        }
    }
}
