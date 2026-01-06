//  AuthGate.swift
//  LegalBestie
//
//  Created by Carolina LC on 23/10/2025.

import SwiftUI

struct AuthGate: View {
    @StateObject private var auth = AuthService()
    @State private var isGuest = false
    
    
    var body: some View {
        NavigationStack {
            if let appUser = auth.user {
             
                
                MainTabView(
                    user: User(
                        userId: appUser.id,
                        firstName: "",
                        lastName: "",
                        email: appUser.email ?? "",
                        createdAt: Date()
                    ),
                    
                    isGuest: false
                ) {
                    try? auth.signOut()
                }
            } else if isGuest {

                MainTabView(
                    user: nil,
                    isGuest: true
                ) {
                    isGuest = false
                }

            } else {
                
                LoginView(onContinueAsGuest: {
                    isGuest = true
                })
                .environmentObject(auth)
                
                }
            }
        }
    }
