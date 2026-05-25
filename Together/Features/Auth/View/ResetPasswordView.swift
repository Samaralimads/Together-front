//
//  ResetPasswordView.swift
//  Together
//
//  Created by Samara Lima da Silva on 12/02/2026.
//

import SwiftUI

struct ResetPasswordView: View {
    let email: String
    let code: String
    @State private var viewModel = AuthViewModel()
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    @State private var navigateToSignIn = false

    var body: some View {
        Background {
            WhiteCard(title: "Reset Password", description: "Enter a new password to secure your account.") {

                VStack(spacing: 10) {
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
                }
                .padding(.vertical, 40)

                if let error = errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 8)
                }

                Button(isLoading ? "Resetting..." : "Reset") {
                    Task {
                        isLoading = true
                        errorMessage = nil
                        do {
                            try await AuthService.resetPassword(
                                email: email,
                                code: code,
                                newPassword: viewModel.password
                            )
                            navigateToSignIn = true
                        } catch {
                            print("Reset password error: \(error)")
                            errorMessage = "Something went wrong. Please try again."
                        }
                        isLoading = false
                    }
                }
                .modifier(AccentButtonModifier())
                .disabled(!viewModel.isPasswordValid || isLoading)
                .opacity(viewModel.isPasswordValid ? 1 : 0.6)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $navigateToSignIn) {
            SignInView()
                .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    ResetPasswordView(email: "samara@test.com", code: "123456")
}
