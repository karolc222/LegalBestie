//  AuthService.swift
//  LegalBestie
//
//  Created by Carolina LC on 23/10/2025.

import Foundation
import FirebaseAuth

final class AuthService: ObservableObject {

    @Published private(set) var user: AppUser?
    
    //stores the listener reference Firebase gives 
    private var handle: AuthStateDidChangeListenerHandle?
    
    init() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, u in
            if let u = u {
                self?.user = AppUser(id: u.uid, email: u.email, isVerified: u.isEmailVerified)
            } else {
                self?.user = nil
            }
        }
    }
    
    deinit {
        if let h = handle {
            Auth.auth().removeStateDidChangeListener(h)
        }
    }
    
    func signUp(email: String, password:String) async throws {
        _ = try await Auth.auth().createUser(withEmail: email, password: password)
        try await Auth.auth().currentUser?.sendEmailVerification()
    }
    
    func signIn(email: String, password: String) async throws {
        _ = try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func sendPasswordReset(email:String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
}
