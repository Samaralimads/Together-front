//
//  PairingSucessfulView.swift
//  Together
//
//  Created by Samara Lima da Silva on 10/02/2026.
//

import SwiftUI

struct PairingSucessfulView: View {
    @State private var logoOpacity = 0.0
    
    var body: some View {
        
        Background{
            
            VStack {
                
                Text("It's always better")
                    .font(.custom("IvyJournal-LightItalic", size: 36))
                    .kerning(4)
                    .foregroundColor(.preto)
                
                Text("Together")
                    .font(.custom("IvyJournal-SemiBoldItalic", size: 64))
                    .foregroundColor(.preto)
                
                Spacer()
                
                Image("logoPaired")
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
                
                Text("You are now paired with Name!")
                    .font(.custom("IvyJournal-Thin", size: 27))
                    .foregroundColor(.preto)
                    .multilineTextAlignment(.center)
                
                NavigationLink(destination: SignUpView()) {
                    Text("Go to dashboard")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.preto)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color.branco)
                        .cornerRadius(50
                        )
                }
                .padding(.top, 30)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 40)
        }
    }
}

#Preview {
    PairingSucessfulView()
}
