//
//  SigninView.swift
//  Together
//
//  Created by Samara Lima da Silva on 10/02/2026.
//

import SwiftUI

struct SignInView: View {
    @State private var viewModel = AuthViewModel()
    @State private var signInTrigger = false
    @State private var showForgotPassword = false
    @Environment(AppState.self) private var appState

    var body: some View {
        Background {
            WhiteCard(title: "Welcome Back!", description: "Sign in to continue building memories and discovering new activities together.") {

                VStack(spacing: 10) {
                    InputField(
                        placeholder: "Email",
                        type: .email,
                        text: $viewModel.email,
                        isValid: viewModel.isEmailValid
                    )

                    InputField(
                        placeholder: "Password",
                        type: .password,
                        text: $viewModel.password,
                        isValid: viewModel.isPasswordValid,
                        passwordRequirements: PasswordRequirements(
                            hasUppercase: viewModel.hasUppercase,
                            hasNumber: viewModel.hasNumber,
                            hasMinLength: viewModel.hasMinLength
                        )
                    )
                    
                    HStack {
                        Spacer()
                        Button("Forgot your password?") {
                            showForgotPassword = true
                        }
                        .font(.footnote)
                        .foregroundColor(.accent)
                        .fontWeight(.semibold)
                        .zIndex(1)
                    }
                    .padding(.bottom, 16)
                    
                }
                .padding(.vertical, 40)

                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 8)
                }

                Button("Sign In") {
                    signInTrigger = true
                }
                .task(id: signInTrigger) {
                    guard signInTrigger else { return }
                    await viewModel.signIn(appState: appState)
                }
                .modifier(AccentButtonModifier())
                .disabled(!viewModel.canSignIn)
                .opacity(viewModel.canSignIn ? 1 : 0.6)

                Text("or")
                    .foregroundColor(.gray)

                Button {
                    // TODO: Sign in with Apple
                } label: {
                    Text(" Sign in with Apple")
                        .fontWeight(.semibold)
                        .foregroundColor(.preto)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .cornerRadius(30)
                        .glassEffect()
                        .shadow(color: .black.opacity(0.13), radius: 2, x: 0, y: 4)
                }

                HStack {
                    Text("Already have an account?")
                    NavigationLink("Sign up") {
                        SignUpView()
                            .navigationBarBackButtonHidden(true)
                    }
                    .foregroundColor(.accent)
                    .fontWeight(.bold)
                }
                .font(.footnote)
                .padding(.top, 30)
            }
        }
        .navigationDestination(isPresented: $showForgotPassword) {
            ForgotPasswordView()
        }
    }
}

#Preview {
    SignInView()
        .environment(AppState())
}
