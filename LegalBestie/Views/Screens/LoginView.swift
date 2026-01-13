//  LoginView.swift
//  LegalBestie
//
//  Created by Carolina LC on 23/10/2025.

import SwiftUI
import FirebaseAuth
private let brandRose = Color(red: 0.965, green: 0.29, blue: 0.54)



struct LoginView: View {
    
    @EnvironmentObject var auth: AuthService
    
    var onContinueAsGuest: (() -> Void)? = nil
    
    @StateObject private var viewModel = LoginViewModel()
    @FocusState private var focused: Bool
    
    
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                LinearGradient(
                    colors: [brandRose.opacity(0.2), Color(.systemBackground)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                ScrollView {
                    VStack(spacing: 18) {
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(brandRose.opacity(0.25))
                                    .frame(width: 75, height: 75)

                                Text("⚖️")
                                    .font(.system(size: 35))
                            }

                            Text("Legal Bestie")
                                .font(.system(size: 34, weight: .semibold, design: .serif))

                                Text("Practical legal help and guidance")
                                .foregroundStyle(.secondary)
                                .font( .callout)
                                .padding(.horizontal, 25)
                                .multilineTextAlignment(.center)
                                
                        }
                        .padding(.top, 40)
                        


                        card(title: "SIGN IN") {
                            TextField("email", text: $viewModel.email)
                                .font(.callout)
                                .foregroundStyle(.primary)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .textContentType(.username)
                                .autocorrectionDisabled()
                                .focused($focused)
                            SecureField("password (min 8 characters)", text: $viewModel.password)
                                .font(.callout)
                                .foregroundStyle(.primary)
                                .textContentType(.password)
                                .focused($focused)

                            Button {
                                focused = false
                                Task { await viewModel.signIn(auth: auth) }
                            } label: {
                                HStack {
                                    if viewModel.isLoading {
                                        ProgressView().controlSize(.small)
                                    } else {
                                        Image(systemName: "arrow.right.circle.fill")
                                    }
                                    Text(viewModel.isLoading ? "Signing in..." : "Sign in")
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(brandRose)
                            .disabled(viewModel.isLoading || viewModel.email.isEmpty || viewModel.password.isEmpty)
                        }

                        if !viewModel.message.isEmpty {
                            Text(viewModel.message)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 20)
                                .padding(.horizontal, 10)
                        }

                        
                        
                        card(title: "YOU NEW HERE?") {
                            Button {
                                focused = false
                                Task { await viewModel.signUp(auth: auth) }
                            } label: {
                                HStack {
                                    Image(systemName: "person.badge.plus")
                                    Text(viewModel.isLoading ? "Creating..." : "Create account")
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                            .tint(brandRose)
                            .disabled(viewModel.isLoading || viewModel.email.isEmpty || viewModel.password.count < 7)

                            Button {
                                focused = false
                                Task { await viewModel.resetPassword(auth: auth) }
                            } label: {
                                HStack {
                                    Image(systemName: "key.fill")
                                    Text("Forgot password?")
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                            .tint(brandRose)
                            .disabled(viewModel.isLoading || viewModel.email.isEmpty)
                        }
                        

                        if let guestAction = onContinueAsGuest {
                            card(title: "BROWSE WITHOUT SIGN UP") {
                                Button {
                                    focused = false
                                    guestAction()
                                } label: {
                                    HStack {
                                        Image(systemName: "person.fill.questionmark")
                                        Text("Continue as Guest")
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.bordered)
                                .tint(brandRose)

                                Text("You can explore the app but won't be able to save reports.")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        


                        Spacer(minLength: 15)
                    }
                    .padding(.horizontal, 15)
                    .padding(.bottom, 25)
                }
            }
    
            .tint(brandRose)
        }
    }


    private func card < Content: View> (title: String,
        @ViewBuilder content: () -> Content) -> some View {
        
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.bottom, 2)
            VStack(spacing: 10) {
                content()
            }
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .stroke(brandRose.opacity(0.5), lineWidth: 1)
        )
    }
}
