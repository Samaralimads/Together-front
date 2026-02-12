//
//  ForgotPasswordView.swift
//  Together
//
//  Created by Samara Lima da Silva on 11/02/2026.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var viewModel = AuthViewModel()
    
    var body: some View {
        Background{
            
            WhiteCard(title: "Forgot your password?", description:"We will send a password reset link to the email entered bellow:" ){
                
                InputField(
                    placeholder: "Email",
                    type: .email,
                    text: $viewModel.email,
                    viewModel: viewModel)
                .padding(.vertical, 60)
                
                AccentButton(title: "Reset Password") {
                    //TODO: Alert "A 4-digit code was sent to your email
                }
            }
        }
    }
}

#Preview {
    ForgotPasswordView()
}
