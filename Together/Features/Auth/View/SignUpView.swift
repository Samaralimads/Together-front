//
//  SignupView.swift
//  Together
//
//  Created by Samara Lima da Silva on 10/02/2026.
//

import SwiftUI

struct SignUpView: View {
    @State private var viewModel = AuthViewModel()
    
    var body: some View {
        Background{
            
            WhiteCard(title: "Create Your Account", description: "Sign up to begin planning meaningful moments as a couple.") {
                
                VStack(spacing: 10){
                    
                    InputField(
                        placeholder: "Full Name",
                        type: .name,
                        text: $viewModel.name,
                        isValid: viewModel.isNameValid
                    )
                    
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
                
                Button("Sign Up") {
                    //add action
                }
                .modifier(AccentButtonModifier())
                
                Text("or")
                    .foregroundColor(.gray)
                
                Button{
                    
                } label: {
                    Text(" Sign up with Apple")
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
                    NavigationLink("Sign in") {
                        SignInView()
                            .navigationBarBackButtonHidden(true)
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
    SignUpView()
}
