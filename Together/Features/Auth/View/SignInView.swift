//
//  SigninView.swift
//  Together
//
//  Created by Samara Lima da Silva on 10/02/2026.
//

import SwiftUI

struct SignInView: View {
    @State private var viewModel = AuthViewModel()
    
    var body: some View {
        Background{
            
            WhiteCard(title: "Welcome Back!", description: "Sign in to continue building memories and discovering new activities together.") {
                
                VStack(spacing: 10){
                    
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
                        NavigationLink("Forgot your password?") {
                            ForgotPasswordView()
                        }
                        .font(.footnote)
                        .foregroundColor(.accent)
                        .fontWeight(.semibold)
                    }
                    .padding(.top, 4)
                    
                    
                }
                .padding(.vertical, 40)
                
                
                AccentButton(title: "Sign In") {
                    //add action
                }
                
                Text("or")
                    .foregroundColor(.gray)
                
                Button{
                    
                } label: {
                    Text(" Sign in with Apple")
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
                    }
                    .foregroundColor(.accent)
                    .fontWeight(.bold)
                }
                .font(.footnote)
                .padding(.top, 30)
                
            }
        }
    }
}
#Preview {
    SignInView()
}
