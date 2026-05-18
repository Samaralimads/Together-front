//
//  ForgotPasswordView.swift
//  Together
//
//  Created by Samara Lima da Silva on 11/02/2026.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var viewModel = AuthViewModel()
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    @State private var navigateToCode = false

    var body: some View {
        Background {
            WhiteCard(title: "Forgot your password?", description: "We will send a reset code to the email entered below:") {

                InputField(
                    placeholder: "Email",
                    type: .email,
                    text: $viewModel.email,
                    isValid: viewModel.isEmailValid
                )
                .padding(.vertical, 60)

                if let error = errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 8)
                }

                Button("Reset Password") {
                    Task {
                        isLoading = true
                        errorMessage = nil
                        do {
                            try await AuthService.forgotPassword(email: viewModel.email)
                            navigateToCode = true
                        } catch {
                            errorMessage = error.localizedDescription
                        }
                        isLoading = false
                    }
                }
                .modifier(AccentButtonModifier())
                .disabled(!viewModel.isEmailValid || isLoading)
                .opacity(viewModel.isEmailValid ? 1 : 0.6)
            }
        }
        .navigationDestination(isPresented: $navigateToCode) {
            ResetCodeView(email: viewModel.email)
        }
    }
}

#Preview {
    ForgotPasswordView()
}
