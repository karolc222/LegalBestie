//  AuthService.swift
//  LegalBestie
//
//  Created by Carolina LC on 23/10/2025.

import Foundation
import FirebaseAuth

@MainActor
final class AuthService: ObservableObject {

    @Published private(set) var user: AppUser?

    private var authHandle: AuthStateDidChangeListenerHandle?

    init() {
        authHandle = Auth.auth().addStateDidChangeListener { [weak self] _, firebaseUser in
            guard let self else { return }

            if let firebaseUser {
                self.user = AppUser(
                    id: firebaseUser.uid,
                    email: firebaseUser.email,
                    isVerified: firebaseUser.isEmailVerified
                )
            } else {
                self.user = nil
            }
        }
    }

    deinit {
        if let authHandle {
            Auth.auth().removeStateDidChangeListener(authHandle)
        }
    }


    func signUp(email: String, password: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        try await result.user.sendEmailVerification()
    }

    func signIn(email: String, password: String) async throws {
        _ = try await Auth.auth().signIn(withEmail: email, password: password)
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    func sendPasswordReset(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
}
