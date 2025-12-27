//  AuthGate.swift
//  LegalBestie
//
//  Created by Carolina LC on 23/10/2025.

import SwiftUI

struct AuthGate: View {
    @StateObject private var auth = AuthService()
    
    var body: some View {
        
            if let u = auth.user {
                ProfileView(user: u) { try? auth.signOut() }
            } else {
                LoginView().environmentObject(auth)
            }
    }
}
