//
//  ResetPasswordView.swift
//  Together
//
//  Created by Samara Lima da Silva on 12/02/2026.
//

import SwiftUI

struct ResetPasswordView: View {
    @State private var viewModel = AuthViewModel()
    
    var body: some View {
        Background{
            
            WhiteCard(title: "Reset Password", description: "Enter a new password to secure your account."){
                
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
                
                Button("Reset") {
                    //TODO: Alert then go back to login
                }
                .modifier(AccentButtonModifier())
                
            }
            
        }
    }
}

#Preview {
    ResetPasswordView()
}
