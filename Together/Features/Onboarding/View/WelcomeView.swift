//
//  WelcomeView.swift
//  Together
//
//  Created by Samara Lima da Silva on 10/02/2026.
//

import SwiftUI

struct WelcomeView: View {
    @State private var logoOpacity = 0.0
    
    var body: some View {
        
        Background{
            
            VStack {
                
                Text("Welcome to")
                    .font(.custom("IvyJournal-LightItalic", size: 36))
                    .kerning(4)
                    .foregroundColor(.preto)
                
                Text("Together")
                    .font(.custom("IvyJournal-SemiBoldItalic", size: 64))
                    .foregroundColor(.preto)
                
                Spacer()
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 270, height: 300)
                    .opacity(logoOpacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 3)) {
                            logoOpacity = 0.9
                        }
                    }
                
                Spacer()
                
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
                
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 40)
        }
    }
}

#Preview {
    WelcomeView()
}
