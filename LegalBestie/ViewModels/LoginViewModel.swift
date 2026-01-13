//  LoginViewModel.swift
//  LegalBestie
//
//  Created by Carolina LC on 01/01/2026.

import Foundation
import FirebaseAuth

@MainActor
final class LoginViewModel: ObservableObject {

    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var message: String = ""
    @Published var isLoading: Bool = false

    
    
    func signIn(auth: AuthService) async {
        isLoading = true
        defer { isLoading = false }

        do {
            try await auth.signIn(email: email, password: password)
        } catch {
            handleError(error)
        }
    }

    
    
    func signUp(auth: AuthService) async {
        isLoading = true
        defer { isLoading = false }
        do {
            try await auth.signUp(email: email, password: password)
            message = "Verification email sent."
        } catch {
            handleError(error)
        }
    }

    
    func resetPassword(auth: AuthService) async {
        isLoading = true
        defer { isLoading = false }

        do {
            try await auth.sendPasswordReset(email: email)
            message = "Password reset email sent."
        } catch {
            handleError(error)
        }
    }

    
    private func handleError(_ error: Error) {
        let code = (error as NSError).code

        
        switch code {
        case AuthErrorCode.invalidEmail.rawValue:
            message = "Invalid email address."
        case AuthErrorCode.wrongPassword.rawValue,
             AuthErrorCode.userNotFound.rawValue:
            message = "Incorrect email or password."
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            message = "Email already in use."
        case AuthErrorCode.weakPassword.rawValue:
            message = "Password is too weak."
        default:
            message = "Authentication failed."
        }
    }
}
