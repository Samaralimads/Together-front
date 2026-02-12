//
//  WelcomeView.swift
//  Together
//
//  Created by Samara Lima da Silva on 10/02/2026.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        
        Background{
            
            VStack {
                Spacer()
                
                //MARK: Titles
                Text("Welcome to")
                    .font(.custom("IvyJournal-LightItalic", size: 36))
                    .kerning(4)
                    .foregroundColor(.preto)
                
                Text("Together")
                    .font(.custom("IvyJournal-SemiBoldItalic", size: 64))
                    .foregroundColor(.preto)
                
                Spacer()
                
                //MARK: Logo
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 260, height: 300)
                
                Spacer()
                
                //MARK: Buttons
                VStack(spacing: 16) {
                    
                    NavigationLink(destination: SignUpView()) {
                        Text("Create Account")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.preto)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.branco)
                            .cornerRadius(50
                            )
                    }
                    
                    NavigationLink(destination: SignInView()) {
                        Text("Log in")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.branco)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .overlay(
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color.branco, lineWidth: 1.5)
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 50)
            }
        }
    }
}

#Preview {
    WelcomeView()
}
