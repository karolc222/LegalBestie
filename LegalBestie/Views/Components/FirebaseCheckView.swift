//
//  FirebaseCheckView.swift
//  LegalBuddy
//
//  Created by Carolina LC on 23/10/2025.
//

import SwiftUI
import FirebaseAuth

struct FirebaseCheckView: View {
    @State private var message = "Ready to test Firebase."

    var body: some View {
        VStack(spacing: 16) {
            Text(message).multilineTextAlignment(.center)
            Button("Test Anonymous Login") {
                Task {
                    do {
                        let result = try await Auth.auth().signInAnonymously()
                        message = "✅ Connected. UID: \(result.user.uid)"
                        try Auth.auth().signOut()
                    } catch {
                        message = "❌ \(error.localizedDescription)"
                    }
                }
            }
        }
        .padding()
    }
}
