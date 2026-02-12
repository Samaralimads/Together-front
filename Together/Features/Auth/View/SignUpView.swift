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
            
            WhiteCard(title: "Create Your Account", description: "Write something cool here") {
                
                VStack(spacing: 10){
                    
                    InputField(
                        placeholder: "Name",
                        type: .name,
                        text: $viewModel.name,
                        viewModel: viewModel
                    )
                    
                    InputField(
                        placeholder: "Email",
                        type: .email,
                        text: $viewModel.email,
                        viewModel: viewModel
                    )
                    
                    InputField(
                        placeholder: "Password",
                        type: .password,
                        text: $viewModel.password,
                        viewModel: viewModel
                    )
                    
                }
                .padding(.vertical, 40)
                
                AccentButton(title: "Sign Up") {
                    //add action
                }
                
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
