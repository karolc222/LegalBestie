//  AuthGate.swift
//  LegalBestie
//
//  Created by Carolina LC on 23/10/2025.

import SwiftUI
import Combine

struct AuthGate: View {
    @StateObject private var auth = AuthService()
    @State private var isGuest = false
    
    var body: some View {
        NavigationStack {
            if let user = auth.user {
                //authentication
                MainTabView(user: user, isGuest: false) {
                    try? auth.signOut()
                }
                
            } else if isGuest {
                // continue without authentication
                MainTabView(
                    user: AuthService.AppUser(
                        id: "guest",
                        email: nil,
                        isVerified: false
                    ),
                    isGuest: true
                ) {
                    isGuest = false
                }

            } else {
                //registration
                LoginView(onContinueAsGuest: {
                    isGuest = true
                })
                .environmentObject(auth)
                
                }
            }
        }
    }
