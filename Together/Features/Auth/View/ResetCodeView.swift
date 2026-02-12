//
//  ResetPasswordView.swift
//  Together
//
//  Created by Samara Lima da Silva on 12/02/2026.
//

import SwiftUI

struct ResetCodeView: View {
    @State private var code: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        Background{
            
            //TODO: Add user vm.email
            WhiteCard(title: "Reset Password", description: "A 4-digit code was sent to user email"){
                
                HStack(spacing: 16) {
                    ForEach(0..<4) { index in
                        CodeDigitBox(
                            digit: digit(at: index),
                            isActive: code.count == index
                        )
                    }
                }
                .padding(.vertical, 40)
                
                //TODO: Add timer and  navigate to ForgotPasswordView() when < 0
                //check for .contentTransition(.numericText())
                Text("Code valid for 04:02")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    
                
                
                // Hidden TextField
                TextField("", text: $code)
                    .keyboardType(.numberPad)
                    .focused($isFocused)
                    .opacity(0)
                    .frame(height: 0)
            }
        }
        .onAppear {
            isFocused = true
        }
        .onChange(of: code) { _, newValue in
            if newValue.count > 4 {
                code = String(newValue.prefix(4))
            }
        }
    }
    
    private func digit(at index: Int) -> String {
        guard index < code.count else { return "" }
        let stringIndex = code.index(code.startIndex, offsetBy: index)
        return String(code[stringIndex])
    }
}

#Preview {
    ResetCodeView()
}
