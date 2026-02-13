//
//  ShareCodePairingView.swift
//  Together
//
//  Created by Samara Lima da Silva on 13/02/2026.
//

import SwiftUI

struct ShareCodePairingView: View {
    @State private var code = "123456"
    @FocusState private var isFocused: Bool
    
    var body: some View {
        Background{
            
            WhiteCard(title: "First one here?", description: "Share this code with your partner to connect your accounts and start planning activities together."){
                
                HStack(spacing: 10) {
                    ForEach(Array(code), id: \.self) { character in
                        CodeDigitBox(
                            digit: String(character),
                            isActive: false
                        )
                    }
                }
                .padding(.vertical, 40)
                
                ShareLink(
                    item: code,
                    subject: Text("Pairing Code"),
                    message: Text("Join me using this pairing code: \(code)")
                ) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share Code")
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        Image("buttonBG")
                            .resizable()
                            .aspectRatio(contentMode: .fill))
                    .cornerRadius(30)
                    .shadow(color: .black.opacity(0.13), radius: 2, x: 0, y: 4)
                }
            }
        }
    }
}

#Preview {
    ShareCodePairingView()
}
