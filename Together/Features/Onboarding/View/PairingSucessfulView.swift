//
//  PairingSucessfulView.swift
//  Together
//
//  Created by Samara Lima da Silva on 10/02/2026.
//

import SwiftUI

struct PairingSucessfulView: View {
    var body: some View {
        
        Background{
            
            VStack {
                //MARK: Titles
                Text("It's always better")
                    .font(.custom("IvyJournal-LightItalic", size: 36))
                    .kerning(4)
                    .foregroundColor(.preto)
                
                Text("Together")
                    .font(.custom("IvyJournal-SemiBoldItalic", size: 64))
                    .foregroundColor(.preto)
                
                
                //MARK: Logo
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 260, height: 300)
                
                Text("You are now paired with Name!")
                    .font(.custom("IvyJournal-Thin", size: 27))
                    .foregroundColor(.preto)
                    .multilineTextAlignment(.center)
                
                
                
                    NavigationLink(destination: DashboardView()) {
                        Text("Go to Dashboard")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.preto)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.branco)
                            .cornerRadius(50
                            )
                    }
                    .padding(.top, 20)
            }
                .padding(.horizontal, 20)
                .padding(.vertical, 50)

        }
    }
}


#Preview {
    PairingSucessfulView()
}
